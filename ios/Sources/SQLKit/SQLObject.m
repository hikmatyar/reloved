/* Copyright (c) 2013 Janek Priimann. This code is distributed under the terms and conditions of the MIT license. */

#import "SQLObject.h"
#import "SQLObjectStore.h"

@interface SQLObjectStore(Internal)

- (void)unlockKey:(NSString *)key inTable:(NSString *)table;

@end

#pragma mark -

@implementation SQLObject

- (id)initWithData:(NSData *)data
{
    self = [super init];
    
    if(self) {
        m_data = data;
    }
    
    return self;
}

- (id)initWithData:(NSData *)data store:(SQLObjectStore *)store key:(NSString *)key table:(NSString *)table
{
    self = [super init];
    
    if(self) {
        m_data = data;
        m_store = store;
        m_key = key;
        m_table = table;
    }
    
    return self;
}

@synthesize value = m_value;

- (NSData *)extractData
{
    NSData *data = m_data;
    
    m_data = nil;
    
    return data;
}

#pragma mark NSObject

- (void)dealloc
{
    if(m_table && m_key) {
        [m_store unlockKey:m_key inTable:m_table];
    }
}

@end
