/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebSession.h"
#import "NSDictionary+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_USERID @"user"
#define KEY_TIMESTAMP @"timestamp"

@implementation MFWebSession

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_identifier = [attributes stringForKey:KEY_IDENTIFIER];
        m_userId = [attributes stringForKey:KEY_USERID];
        m_timestamp = [attributes timeIntervalForKey:KEY_TIMESTAMP];
        
        if(m_timestamp < 1.0F) {
            m_timestamp = [NSDate timeIntervalSinceReferenceDate];
        }
        
        if(!m_userId || !m_identifier) {
            MFError(@"user ID or session cannot be nil");
            
            return nil;
        }
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            m_userId, KEY_USERID,
            m_identifier, KEY_IDENTIFIER,
            [NSNumber numberWithDouble:m_timestamp], KEY_TIMESTAMP, nil];
}

@synthesize timestamp = m_timestamp;
@synthesize identifier = m_identifier;
@synthesize userId = m_userId;

@end