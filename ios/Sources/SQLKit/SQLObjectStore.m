/* Copyright (c) 2013 Janek Priimann. This code is distributed under the terms and conditions of the MIT license. */

#import "SQLConnection.h"
#import "SQLCursor.h"
#import "SQLObjectStore.h"

#define PROPERTIES_TABLE @"__properties"
#define ASSOCIATE_TABLE @"__assoc_"
#define TIMESTAMP_KEY @"__timestamp"

#define ASSOCIATE(a, b) [NSString stringWithFormat:ASSOCIATE_TABLE @"%@_%@", a, b]

@implementation SQLObjectStore

- (id)initWithPath:(NSString *)path
{
    return [self initWithPath:path mode:kSQLObjectStoreModeDefault];
}

- (id)initWithPath:(NSString *)path mode:(SQLObjectStoreMode)mode
{
    self = [super init];
    
    if(self) {
        m_mode = mode;
        m_path = path;
        m_tables = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (BOOL)open
{
    if(!m_connection) {
        SQLCursor *cursor;
        
        m_connection = [[SQLConnection alloc] initWithPath:m_path];
        
        if((cursor = [m_connection query:@"SELECT name FROM sqlite_master WHERE type = \"table\"" arguments:nil]) != nil) {
            while([cursor nextObject]) {
                NSString *table = [cursor stringAtIndex:0];
                
                if(table) {
                    [m_tables addObject:table];
                }
            }
        }
        
        m_timestamp = ((NSNumber *)[self propertyForKey:TIMESTAMP_KEY]).doubleValue;
    }
    
    return (m_connection) ? YES : NO;
}

- (BOOL)openForTable:(NSString *)table
{
    if(table && (m_connection || [self open])) {
        if(![m_tables containsObject:table]) {
            [m_tables addObject:table];
            
            if([table hasPrefix:ASSOCIATE_TABLE]) {
                [[m_connection query:[NSString stringWithFormat:
                                      @"CREATE TABLE IF NOT EXISTS %@ ("
                                      @"key1 TEXT NOT NULL, "
                                      @"key2 TEXT NOT NULL, PRIMARY KEY(key1, key2))", table] arguments:nil] execute];
                [[m_connection query:[NSString stringWithFormat:
                                      @"CREATE INDEX %@_index ON %@ (key1, key2)", table, table] arguments:nil] execute];
            } else {
                [[m_connection query:[NSString stringWithFormat:
                                      @"CREATE TABLE IF NOT EXISTS %@ ("
                                      @"key TEXT NOT NULL PRIMARY KEY, "
                                      @"value BLOB NOT NULL, "
                                      @"ttl INTEGER NOT NULL DEFAULT 0)", table] arguments:nil] execute];
                
                if((m_mode & kSQLObjectStoreModeFullIndex) != 0) {
                    [[m_connection query:[NSString stringWithFormat:
                                          @"CREATE INDEX %@_index ON %@ (key)", table, table] arguments:nil] execute];
                }
            }
        }
        
        return YES;
    }
    
    return NO;
}

- (void)close
{
    if(m_connection) {
        [m_tables removeAllObjects];
        m_connection = nil;
    }
}

- (NSArray *)associationsForTable:(NSString *)table1 withTable:(NSString *)table2
{
    NSMutableArray *associations = nil;
    
    if([self open]) {
        if(table1) {
            NSString *prefix = ASSOCIATE(table1, @"");
            
            for(NSString *table in m_tables) {
                if([table hasPrefix:prefix]) {
                    if(!associations) {
                        associations = [NSMutableArray array];
                    }
                    
                    [associations addObject:table];
                }
            }
        } else {
            NSString *prefix = ASSOCIATE(@"", @"");
            NSString *suffix = table2;
            
            for(NSString *table in m_tables) {
                if([table hasPrefix:prefix] && [table hasSuffix:suffix]) {
                    if(!associations) {
                        associations = [NSMutableArray array];
                    }
                    
                    [associations addObject:table];
                }
            }
        }
    }

    return associations;
}

@synthesize path = m_path;

- (NSData *)objectForKey:(NSString *)key inTable:(NSString *)table
{
    if([self open] && table && [m_tables containsObject:table]) {
        SQLCursor *cursor = [m_connection query:[NSString stringWithFormat:@"SELECT value FROM %@ WHERE key = ?", table]
                                      arguments:[NSArray arrayWithObject:key]];
        
        while([cursor nextObject]) {
            return [cursor dataAtIndex:0];
        }
    }
    
    return nil;
}

- (NSData *)objectForKey:(NSString *)key inTable:(NSString *)table ttl:(NSTimeInterval *)ttl
{
    if([self open] && table && [m_tables containsObject:table]) {
        SQLCursor *cursor = [m_connection query:[NSString stringWithFormat:@"SELECT value, ttl FROM %@ WHERE key = ?", table]
                                      arguments:[NSArray arrayWithObject:key]];
        
        while([cursor nextObject]) {
            if(ttl) {
                *ttl = (double)[cursor longAtIndex:1];
            }
            
            return [cursor dataAtIndex:0];
        }
    }
    
    if(ttl) {
        *ttl = 0.0F;
    }
    
    return nil;
}

- (void)setObjectUnlessExists:(NSData *)object forKey:(NSString *)key inTable:(NSString *)table
{
    if([self open] && table && [m_tables containsObject:table]) {
        SQLCursor *cursor = [m_connection query:[NSString stringWithFormat:@"SELECT key FROM %@ WHERE key = ?", table]
                                      arguments:[NSArray arrayWithObject:key]];
        
        while([cursor nextObject]) {
            return;
        }
        
        [self setObject:object forKey:key inTable:table];
    }
}

- (void)setObject:(NSData *)object forKey:(NSString *)key inTable:(NSString *)table
{
    if([self openForTable:table]) {
        if(object) {
            [[m_connection query:[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (key, value) VALUES(?, ?)", table]
                       arguments:[NSArray arrayWithObjects:key, object, nil]] execute];
        } else {
            NSArray *associations = [self associationsForTable:table withTable:nil];
            NSArray *arguments = [NSArray arrayWithObject:key];
            
            for(NSString *association in associations) {
                [[m_connection query:[NSString stringWithFormat:@"DELETE FROM %@ WHERE key1 = ?", association]
                           arguments:arguments] execute];
            }
            
            [[m_connection query:[NSString stringWithFormat:@"DELETE FROM %@ WHERE key = ?", table]
                       arguments:arguments] execute];
        }
    }
}

- (void)setObject:(NSData *)object expires:(NSTimeInterval)expires forKey:(NSString *)key inTable:(NSString *)table
{
    if([self openForTable:table]) {
        if(object) {
            NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
            SQLCursor *cursor;
            long ttl = 0;
            
            // Timetravel into the past!
            if(m_timestamp > timestamp) {
                long delta = round(m_timestamp - timestamp);
                
                for(NSString *t in m_tables) {
                    if(![t isEqualToString:PROPERTIES_TABLE]) {
                        [[m_connection query:[NSString stringWithFormat:@"UPDATE %@ SET ttl = ttl - %lu WHERE ttl <> 0", table, delta] arguments:nil] execute];
                    }
                }
                
                MFLog(@"The clock moved backwards %g -> %g!", m_timestamp, timestamp);
            }
            
            // Don't update the reference timestamp too often
            if(m_timestamp > timestamp || fabs(m_timestamp - timestamp) > 60.0F) {
                m_timestamp = timestamp;
                [self setProperty:[NSNumber numberWithDouble:m_timestamp] forKey:TIMESTAMP_KEY];
            }
            
            cursor = [m_connection query:[NSString stringWithFormat:@"SELECT ttl FROM %@ WHERE key = ?", table]
                               arguments:[NSArray arrayWithObject:key]];
            
            while([cursor nextObject]) {
                ttl = [cursor longAtIndex:0];
            }
            
            if(ttl == 0 || (m_mode & kSQLObjectStoreModeFirstExpires) == 0) {
                if(ttl < (long)expires) {
                    ttl = (long)expires;
                }
            }
            
            [[m_connection query:[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (key, value, ttl) VALUES(?, ?, ?)", table]
                       arguments:[NSArray arrayWithObjects:key, object, [NSNumber numberWithLong:ttl], nil]] execute];
        } else {
            NSArray *associations = [self associationsForTable:table withTable:nil];
            NSArray *arguments = [NSArray arrayWithObject:key];
            
            for(NSString *association in associations) {
                [[m_connection query:[NSString stringWithFormat:@"DELETE FROM %@ WHERE key1 = ?", association]
                           arguments:arguments] execute];
            }
            
            [[m_connection query:[NSString stringWithFormat:@"DELETE FROM %@ WHERE key = ?", table]
                       arguments:arguments] execute];
        }
    }
}

- (NSSet *)allKeysInTable:(NSString *)table
{
    NSMutableSet *allKeys = nil;
    
    if([self open] && table && [m_tables containsObject:table]) {
        SQLCursor *cursor = [m_connection query:[NSString stringWithFormat:@"SELECT key FROM %@", table] arguments:nil];
        
        while([cursor nextObject]) {
            NSString *key = [cursor stringAtIndex:0];
            
            if(key) {
                if(!allKeys) {
                    allKeys = [[NSMutableSet alloc] init];
                }
                
                [allKeys addObject:key];
            }
        }
    }
    
    return allKeys;
}

- (NSDictionary *)allObjectsInTable:(NSString *)table
{
    return [self allObjectsInTable:table usingBlock:NULL];
}

- (NSDictionary *)allObjectsInTable:(NSString *)table usingBlock:(SQLObjectStoreTransformBlock)block
{
    NSMutableDictionary *allObjects = nil;
    
    if([self open] && table && [m_tables containsObject:table]) {
        SQLCursor *cursor = [m_connection query:[NSString stringWithFormat:@"SELECT key, value FROM %@", table] arguments:nil];
        
        while([cursor nextObject]) {
            NSString *key = [cursor stringAtIndex:0];
            
            if(key) {
                if(!allObjects) {
                    allObjects = [[NSMutableDictionary alloc] init];
                }
                
                if(block) {
                    [allObjects setValue:block(key, [cursor dataAtIndex:1]) forKey:key];
                } else {
                    [allObjects setValue:[cursor dataAtIndex:1] forKey:key];
                }
            }
        }
    }
    
    return allObjects;
}

- (void)removeAllObjectsInTable:(NSString *)table
{
    if([self openForTable:table]) {
        NSArray *associations = [self associationsForTable:table withTable:nil];
        
        for(NSString *association in associations) {
            [[m_connection query:[NSString stringWithFormat:@"DELETE FROM %@", association] arguments:nil] execute];
        }
        
        [[m_connection query:[NSString stringWithFormat:@"DELETE FROM %@", table] arguments:nil] execute];
    }
}

- (void)removeAllObjects
{
    if([self open]) {
        for(NSString *table in m_tables) {
            if(![table isEqualToString:PROPERTIES_TABLE]) {
                [self removeAllObjectsInTable:table];
            }
        }
    }
}

- (void)associateKey:(NSString *)key1 inTable:(NSString *)table1 withKey:(NSString *)key2 inTable:(NSString *)table2
{
    NSString *table = ASSOCIATE(table1, table2);
    
    if([self openForTable:table]) {
        [[m_connection query:[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (key1, key2) VALUES(?, ?)", table]
                   arguments:[NSArray arrayWithObjects:key1, key2, nil]] execute];
    }
}

- (void)dissociateKey:(NSString *)key1 inTable:(NSString *)table1 withKey:(NSString *)key2 inTable:(NSString *)table2
{
    NSString *table = ASSOCIATE(table1, table2);
    
    if([self open] && table && [m_tables containsObject:table]) {
        [[m_connection query:[NSString stringWithFormat:@"DELETE FROM %@ WHERE key1 = ? AND key2 = ?", table] arguments:[NSArray arrayWithObjects:key1, key2, nil]] execute];
    }
}

- (void)dissociateKey:(NSString *)key1 inTable:(NSString *)table1 withKeysInTable:(NSString *)table2
{
    NSString *table = ASSOCIATE(table1, table2);
    
    if([self open] && table && [m_tables containsObject:table]) {
        [[m_connection query:[NSString stringWithFormat:@"DELETE FROM %@ WHERE key1 = ?", table] arguments:[NSArray arrayWithObject:key1]] execute];
    }
}

- (NSArray *)associationsForKey:(NSString *)key1 inTable:(NSString *)table1 forTable:(NSString *)table2
{
    return [self associationsForKey:key1 inTable:table1 forTable:table2 usingBlock:NULL];
}

- (NSArray *)associationsForKey:(NSString *)key1 inTable:(NSString *)table1 forTable:(NSString *)table2 usingBlock:(SQLObjectStoreTransformBlock)block
{
    NSString *table = ASSOCIATE(table1, table2);
    NSMutableArray *associations = nil;
    
    if([self open] && table && [m_tables containsObject:table]) {
        SQLCursor *cursor = [m_connection query:(block)
                             ? [NSString stringWithFormat:@"SELECT key, value FROM %@ WHERE key IN (SELECT key2 FROM %@ WHERE key1 = ?)", table2, table]
                             : [NSString stringWithFormat:@"SELECT key2 FROM %@ WHERE key1 = ?", table] arguments:[NSArray arrayWithObject:key1]];
        
        while([cursor nextObject]) {
            id association = (block) ? block([cursor stringAtIndex:0], [cursor dataAtIndex:1]) : [cursor stringAtIndex:0];
            
            if(association) {
                if(!associations) {
                    associations = [NSMutableArray array];
                }
                
                [associations addObject:association];
            }
        }
    }
    
    
    return associations;
}

- (void)invalidateObjectsInTable:(NSString *)table
{
    [self invalidateObjectsInTable:table usingBlock:NULL];
}

- (void)invalidateObjectsInTable:(NSString *)table usingBlock:(SQLObjectStoreMatchBlock)block
{
    if([self open] && table && [m_tables containsObject:table]) {
        NSMutableString *query = [[NSMutableString alloc] init];
        NSArray *associations = [self associationsForTable:nil withTable:table];
        NSMutableArray *keys = nil;
        SQLCursor *cursor;
        
        [query appendFormat:@"SELECT key FROM %@ WHERE ttl <> 0 AND ttl < ?", table];
        
        for(NSString *association in associations) {
            [query appendFormat:@" AND NOT EXISTS (SELECT * FROM %@ WHERE key1 = key LIMIT 1)", association];
        }
        
        cursor = [m_connection query:query arguments:[NSArray arrayWithObject:[NSNumber numberWithLong:m_timestamp]]];
        
        while([cursor nextObject]) {
            NSString *key = [cursor stringAtIndex:0];
            
            if(!keys) {
                keys = [[NSMutableArray alloc] init];
            }
            
            [keys addObject:key];
        }
        
        if(keys.count > 0) {
            associations = [self associationsForTable:table withTable:nil];
            query = [[NSMutableString alloc] init];
            
            MFDebug(@"Deleting keys %@ from table %@", [keys componentsJoinedByString:@","], table);
            
            for(NSString *association in associations) {
                query = [[NSMutableString alloc] init];
                [query appendFormat:@"DELETE FROM %@ WHERE key1 IN (", association];
                
                for(NSInteger i = 0, c = keys.count; i < c; i++) {
                    [query appendString:(i > 0) ? @",?" : @"?"];
                }
                
                [query appendString:@")"];
                
                [[m_connection query:query arguments:keys] execute];
            }
            
            query = [[NSMutableString alloc] init];
            [query appendFormat:@"DELETE FROM %@ WHERE key IN (", table];
            
            for(NSInteger i = 0, c = keys.count; i < c; i++) {
                [query appendString:(i > 0) ? @",?" : @"?"];
            }
            
            [query appendString:@")"];
            
            [[m_connection query:query arguments:keys] execute];
            
            if(block) {
                for(NSString *key in keys) {
                    block(table, key);
                }
            }
        }
    }
}

- (void)invalidateObjects
{
    [self invalidateObjectsUsingBlock:NULL];
}

- (void)invalidateObjectsUsingBlock:(SQLObjectStoreMatchBlock)block
{
    if([self open]) {
        for(NSString *table in [m_tables copy]) {
            if(![table isEqualToString:PROPERTIES_TABLE] && ![table hasPrefix:ASSOCIATE_TABLE]) {
                [self invalidateObjectsInTable:table usingBlock:block];
            }
        }
    }
}

- (id)propertyForKey:(NSString *)key
{
    if([self open] && [m_tables containsObject:PROPERTIES_TABLE]) {
        SQLCursor *cursor = [m_connection query:[NSString stringWithFormat:@"SELECT value FROM " PROPERTIES_TABLE @" WHERE key = ?"]
                                      arguments:[NSArray arrayWithObject:key]];
        
        while([cursor nextObject]) {
            return [NSKeyedUnarchiver unarchiveObjectWithData:[cursor dataAtIndex:0]];
        }
    }
    
    return nil;
}

- (void)setProperty:(id)property forKey:(NSString *)key
{
    if([self openForTable:PROPERTIES_TABLE]) {
        NSData *data = (property) ? [NSKeyedArchiver archivedDataWithRootObject:property] : nil;
        
        if(data) {
            [[m_connection query:@"INSERT OR REPLACE INTO " PROPERTIES_TABLE @" (key, value) VALUES(?, ?)"
                       arguments:[NSArray arrayWithObjects:key, data, nil]] execute];
        } else {
            [[m_connection query:@"DELETE FROM " PROPERTIES_TABLE @" WHERE key = ?"
                       arguments:[NSArray arrayWithObject:key]] execute];
        }
    }
}

@end
