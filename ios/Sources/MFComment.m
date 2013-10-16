/* Copyright (c) 2013 Meep Factory OU */

#import "MFComment.h"
#import "NSDate+Additions.h"
#import "NSDictionary+Additions.h"
#import "NSString+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_USER @"user"
#define KEY_DATE @"date"
#define KEY_MODIFIED @"mod"
#define KEY_MESSAGE @"message"

@implementation MFComment

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_identifier = [attributes identifierForKey:KEY_IDENTIFIER];
        m_userId = [attributes identifierForKey:KEY_USER];
        m_message = [attributes stringForKey:KEY_MESSAGE];
        m_date = [attributes stringForKey:KEY_DATE].datetimeValue;
        m_modified = [attributes stringForKey:KEY_MODIFIED].datetimeValue;
        
        if(!m_identifier || !m_date || !m_userId) {
            return nil;
        }
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        m_identifier, KEY_IDENTIFIER,
        m_userId, KEY_USER,
        m_date.datetimeString, KEY_DATE,
        m_message, KEY_MESSAGE,
        m_modified.datetimeString, KEY_MODIFIED, nil];
}

@synthesize identifier = m_identifier;
@synthesize userId = m_userId;
@synthesize date = m_date;
@synthesize modified = m_modified;
@synthesize message = m_message;

#pragma mark NSObject

- (NSString *)description
{
    return (m_message) ? m_message : [NSString stringWithFormat:@"<message:%@>", m_identifier];
}

@end
