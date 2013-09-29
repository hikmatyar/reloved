/* Copyright (c) 2013 Janek Priimann. This code is distributed under the terms and conditions of the MIT license. */

#import <Foundation/Foundation.h>

@class SQLObjectStore;

@interface SQLObject : NSObject
{
    @private
    id m_value;
    NSData *m_data;
    NSString *m_table;
    NSString *m_key;
    __unsafe_unretained SQLObjectStore *m_store;
}

- (id)initWithData:(NSData *)data;

@property (nonatomic, retain) id value;

- (NSData *)extractData;

@end
