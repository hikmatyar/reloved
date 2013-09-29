/* Copyright (c) 2013 Janek Priimann. This code is distributed under the terms and conditions of the MIT license. */

#import <Foundation/Foundation.h>

@class SQLCursor;

@interface SQLConnection : NSObject
{
    @private
    void *m_connection;
    NSString *m_name;
    NSString *m_path;
}

- (id)initWithPath:(NSString *)path;
- (id)initWithPath:(NSString *)path name:(NSString *)name;

- (SQLCursor *)query:(NSString *)query arguments:(NSArray *)arguments;
- (SQLCursor *)fetch:(NSString *)query, ...;
- (BOOL)execute:(NSString *)query, ...;

- (BOOL)beginTransaction;
- (BOOL)rollbackTransaction;
- (BOOL)commitTransaction;

@property (nonatomic, retain, readonly) NSString *error;
@property (nonatomic, assign, readonly) long lastInsertRowId;
@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, retain, readonly) NSString *path;

@end
