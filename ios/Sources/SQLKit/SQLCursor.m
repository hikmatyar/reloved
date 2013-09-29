/* Copyright (c) 2013 Janek Priimann. This code is distributed under the terms and conditions of the MIT license. */

#import <sqlite3.h>
#import "SQLConnection.h"
#import "SQLCursor.h"

#define C(c) ((sqlite3_stmt *)c)

@implementation SQLCursor

- (id)initWithConnection:(SQLConnection *)connection cursor:(void *)cursor
{
    self = [super init];
    
    if(self) {
        m_connection = connection;
        m_cursor = cursor;
        m_count = sqlite3_data_count(C(cursor));
    }
    
    return self;
}

@synthesize connection = m_connection;
@synthesize numberOfRows = m_count;

@dynamic numberOfColumns;

- (NSInteger)numberOfColumns
{
	return (m_cursor) ? sqlite3_column_count(C(m_cursor)) : 0;
}

- (NSData *)dataAtIndex:(NSInteger)index
{
	if(m_cursor && sqlite3_column_type(C(m_cursor), index) != SQLITE_NULL) {
		int length = sqlite3_column_bytes(C(m_cursor), index);
		
		if(length > 0) {
			return [NSData dataWithBytes:sqlite3_column_blob(C(m_cursor), index) length:length];
		}
	}
	
	return nil;
}

- (long)longAtIndex:(NSInteger)index
{
	return (m_cursor) ? sqlite3_column_int64(C(m_cursor), index) : 0;
}

- (BOOL)nullAtIndex:(NSInteger)index
{
    return (m_cursor && sqlite3_column_type(C(m_cursor), index) != SQLITE_NULL) ? NO : YES;
}

- (NSNumber *)numberAtIndex:(NSInteger)index
{
    if(m_cursor) {
		switch(sqlite3_column_type(C(m_cursor), index)) {
			case SQLITE_INTEGER:
				return [NSNumber numberWithLongLong:sqlite3_column_int64(C(m_cursor), index)];
			case SQLITE_FLOAT:
				return [NSNumber numberWithDouble:sqlite3_column_double(C(m_cursor), index)];
		}
	}
	
	return nil;
}

- (NSString *)stringAtIndex:(NSInteger)index
{
	return (m_cursor && sqlite3_column_type(C(m_cursor), index) == SQLITE_TEXT) ? [NSString stringWithUTF8String:(const char *)sqlite3_column_text(C(m_cursor), index)] : nil;
}

- (BOOL)execute
{
	if(m_cursor) {
		while(1) {
			if(sqlite3_step(C(m_cursor)) != SQLITE_ROW) {
				break;
			}
		}
	}
	
	[self close];
    
    return YES;
}

- (void)close
{
	if(m_cursor) {
#ifdef DEBUG_SQL
		NSLog(@"(returned %d rows)", m_count);
#endif
        
		sqlite3_finalize(C(m_cursor));
		m_cursor = NULL;
	}
}

#pragma mark NSEnumerator

- (id)nextObject
{
	if(m_cursor) {
		if(sqlite3_step(C(m_cursor)) == SQLITE_ROW) {
			return self;
		} else {
			[self close];
		}
	}
	
	return nil;
}

#pragma mark NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained *)stackbuf count:(NSUInteger)len
{
	if(m_cursor && state->state < m_count && sqlite3_step(C(m_cursor)) == SQLITE_ROW) {
		state->state += 1;
		state->itemsPtr = stackbuf;
		state->itemsPtr[0] = self;
		state->mutationsPtr = &state->extra[0];
		
		return 1;
	} else {
		[self close];
	}
	
    return 0;
}

#pragma mark NSObject

- (void)dealloc
{
	[self close];
}

@end
