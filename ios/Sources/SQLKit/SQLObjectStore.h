/* Copyright (c) 2013 Janek Priimann. This code is distributed under the terms and conditions of the MIT license. */

#import <Foundation/Foundation.h>

@class SQLConnection;

typedef void (^SQLObjectStoreMatchBlock)(NSString *table, NSString *key);
typedef id (^SQLObjectStoreTransformBlock)(NSString *key, NSData *value);

typedef unsigned int SQLObjectStoreMode;

typedef enum _SQLObjectStoreModes {
    kSQLObjectStoreModeDefault = 0x00,
    kSQLObjectStoreModeFirstExpires = (1 << 0),
    kSQLObjectStoreModeFullIndex = (1 << 1)
} SQLObjectStoreModes;

@interface SQLObjectStore : NSObject
{
    @private
    SQLConnection *m_connection;
    SQLObjectStoreMode m_mode;
    NSString *m_path;
    NSMutableSet *m_tables;
    NSTimeInterval m_timestamp;
}

- (id)initWithPath:(NSString *)path;
- (id)initWithPath:(NSString *)path mode:(SQLObjectStoreMode)mode;

@property (nonatomic, retain, readonly) NSString *path;

- (BOOL)open;
- (void)close;

- (id)propertyForKey:(NSString *)key;
- (void)setProperty:(id)property forKey:(NSString *)key;

- (NSData *)objectForKey:(NSString *)key inTable:(NSString *)table;
- (NSData *)objectForKey:(NSString *)key inTable:(NSString *)table ttl:(NSTimeInterval *)ttl;
- (void)setObjectUnlessExists:(NSData *)object forKey:(NSString *)key inTable:(NSString *)table;
- (void)setObject:(NSData *)object forKey:(NSString *)key inTable:(NSString *)table;
- (void)setObject:(NSData *)object expires:(NSTimeInterval)expires forKey:(NSString *)key inTable:(NSString *)table;
- (NSSet *)allKeysInTable:(NSString *)table;
- (NSDictionary *)allObjectsInTable:(NSString *)table;
- (NSDictionary *)allObjectsInTable:(NSString *)table usingBlock:(SQLObjectStoreTransformBlock)block;
- (void)removeAllObjectsInTable:(NSString *)table;
- (void)removeAllObjects;

- (void)associateKey:(NSString *)key inTable:(NSString *)table withKey:(NSString *)key2 inTable:(NSString *)table2;
- (void)dissociateKey:(NSString *)key inTable:(NSString *)table withKey:(NSString *)key2 inTable:(NSString *)table2;
- (void)dissociateKey:(NSString *)key inTable:(NSString *)table withKeysInTable:(NSString *)table2;
- (NSArray *)associationsForKey:(NSString *)key inTable:(NSString *)table forTable:(NSString *)table;
- (NSArray *)associationsForKey:(NSString *)key inTable:(NSString *)table forTable:(NSString *)table usingBlock:(SQLObjectStoreTransformBlock)block;

- (void)invalidateObjectsInTable:(NSString *)table;
- (void)invalidateObjectsInTable:(NSString *)table usingBlock:(SQLObjectStoreMatchBlock)block;
- (void)invalidateObjects;
- (void)invalidateObjectsUsingBlock:(SQLObjectStoreMatchBlock)block;

@end
