/* Copyright (c) 2013 Janek Priimann. This code is distributed under the terms and conditions of the MIT license. */

#import <sqlite3.h>
#import "SQLConnection.h"
#import "SQLCursor.h"

#define C(c) ((sqlite3 *)c)

@interface SQLCursor(Internal)

- (id)initWithConnection:(SQLConnection *)connection cursor:(void *)cursor;

@end

#pragma mark -

@implementation SQLConnection

- (id)initWithPath:(NSString *)path
{
    return [self initWithPath:path name:path.lastPathComponent];
}

- (id)initWithPath:(NSString *)path name:(NSString *)name
{
    self = [super init];
    
    if(self) {
        NSString *directory = [path stringByDeletingLastPathComponent];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        sqlite3 *connection = NULL;
        
        m_name = name;
        m_path = path;
        
        if(![fileManager fileExistsAtPath:directory]) {
            [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
        if(sqlite3_open(path.UTF8String, &connection) == SQLITE_OK) {
            m_connection = connection;
        } else {
            MFError(@"Failed to open database '%@'", name);
            return nil;
        }
    }
    
    return self;
}

- (SQLCursor *)query:(NSString *)query arguments:(NSArray *)arguments
{
    if(query.length > 0 && m_connection) {
		sqlite3_stmt *cursor = NULL;
		
#ifdef DEBUG_SQL
		NSLog(@"%@ (%d) << %@", m_name, arguments.count, query);
#endif
        
		if(sqlite3_prepare_v2(C(m_connection), query.UTF8String, -1, &cursor, NULL) == SQLITE_OK) {
			NSInteger index = 1;
			
			for(NSObject *argument in arguments) {
				if([argument isKindOfClass:[NSNull class]]) {
					sqlite3_bind_null(cursor, index++);
				} else if([argument isKindOfClass:[NSString class]]) {
					sqlite3_bind_text(cursor, index++, ((NSString *)argument).UTF8String, -1, SQLITE_TRANSIENT);
				} else if([argument isKindOfClass:[NSData class]]) {
					sqlite3_bind_blob(cursor, index++, ((NSData *)argument).bytes, ((NSData *)argument).length, SQLITE_TRANSIENT);
				} else if([argument isKindOfClass:[NSNumber class]]) {
                    const char *type = [(NSNumber *)argument objCType];
                    
                    if(strcmp(type, @encode(float)) == 0 || strcmp(type, @encode(double)) == 0) {
						sqlite3_bind_double(cursor, index++, ((NSNumber *)argument).doubleValue);
					} else {
						sqlite3_bind_int64(cursor, index++, ((NSNumber *)argument).longLongValue);
					}
				} else {
					sqlite3_bind_text(cursor, index++, [argument description].UTF8String, -1, SQLITE_TRANSIENT);
				}
			}
			
			return [[SQLCursor alloc] initWithConnection:self cursor:cursor];
		} else {
            NSLog(@"%@ >> %@", m_name, self.error);
			sqlite3_finalize(cursor);
		}
    }
    
    return nil;
}

- (SQLCursor *)query:(NSString *)query arglist:(va_list)arglist
{
    const char *utf8 = query.UTF8String;
    NSMutableArray *arguments = nil;
    NSInteger count = 0;
    
    if(utf8) {
        while(*utf8) {
            if(*utf8 == '?') {
                count++;
            }
            
            utf8++;
        }
    }
    
    for(NSInteger i = 0; i < count; i++) {
        NSObject *argument = va_arg(arglist, NSObject *);
        
        if(!arguments) {
            arguments = [[NSMutableArray alloc] init];
        }
        
        [arguments addObject:(argument) ? argument : [NSNull null]];
    }
    
    return [self query:query arguments:arguments];
}

- (SQLCursor *)fetch:(NSString *)query, ...
{
    SQLCursor *cursor;
	va_list arguments;
	
	va_start(arguments, query);
	cursor = [self query:query arglist:arguments];
	va_end(arguments);
	
	return cursor;
}

- (BOOL)execute:(NSString *)query, ...
{
    SQLCursor *cursor;
	va_list arguments;
	BOOL r;
    
	va_start(arguments, query);
	cursor = [self query:query arglist:arguments];
	r = [cursor execute];
	va_end(arguments);
	
	return r;
}

- (BOOL)beginTransaction
{
	return [[self query:@"BEGIN TRANSACTION" arguments:nil] execute];
}

- (BOOL)rollbackTransaction
{
	return [[self query:@"ROLLBACK" arguments:nil] execute];
}

- (BOOL)commitTransaction
{
	return [[self query:@"COMMIT" arguments:nil] execute];
}

@dynamic error;

- (NSString *)error
{
	const char *error = (m_connection) ? sqlite3_errmsg(C(m_connection)) : NULL;
	
	return (error) ? [NSString stringWithUTF8String:error] : nil;
}

@dynamic lastInsertRowId;

- (long)lastInsertRowId
{
	return (m_connection) ? sqlite3_last_insert_rowid(C(m_connection)) : 0;
}

@synthesize name = m_name;
@synthesize path = m_path;

#pragma mark NSObject

- (void)dealloc
{
    sqlite3_close(C(m_connection));
}

@end
