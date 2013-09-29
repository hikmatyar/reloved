/* Copyright (c) 2013 Janek Priimann. This code is distributed under the terms and conditions of the MIT license. */

#import <Foundation/Foundation.h>

@class SQLConnection;

@interface SQLCursor : NSEnumerator <NSFastEnumeration>
{
    @private
    SQLConnection *m_connection;
	void *m_cursor;
	NSInteger m_count;
}

@property (nonatomic, retain, readonly) SQLConnection *connection;
@property (nonatomic, assign, readonly) NSInteger numberOfRows;
@property (nonatomic, assign, readonly) NSInteger numberOfColumns;

- (NSData *)dataAtIndex:(NSInteger)index;
- (long)longAtIndex:(NSInteger)index;
- (BOOL)nullAtIndex:(NSInteger)index;
- (NSNumber *)numberAtIndex:(NSInteger)index;
- (NSString *)stringAtIndex:(NSInteger)index;

- (BOOL)execute;
- (void)close;

@end
