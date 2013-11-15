/* Copyright (c) 2013 Meep Factory OU */

#import "MFUserDetails.h"
#import "MFWebSession.h"
#import "NSDictionary+Additions.h"

#define KEY_CONTACTS @"contacts"
#define KEY_IDENTIFIER @"session"
#define KEY_USERID @"user"
#define KEY_TIMESTAMP @"timestamp"

@implementation MFWebSession

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        NSDictionary *contacts = [attributes dictionaryForKey:KEY_CONTACTS];
        
        m_identifier = [attributes stringForKey:KEY_IDENTIFIER];
        m_userId = [attributes identifierForKey:KEY_USERID];
        m_timestamp = [attributes timeIntervalForKey:KEY_TIMESTAMP];
        
        if(contacts.count > 0) {
            m_contacts = [[MFUserDetails alloc] initWithAttributes:contacts];
        }
        
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
            [NSNumber numberWithDouble:m_timestamp], KEY_TIMESTAMP,
            m_contacts.attributes, KEY_CONTACTS, nil];
}

@synthesize contacts = m_contacts;
@synthesize timestamp = m_timestamp;
@synthesize identifier = m_identifier;
@synthesize userId = m_userId;

#pragma mark MFWebRequestTransform

+ (id)parseFromObject:(id)object
{
    return ([object isKindOfClass:[NSDictionary class]]) ? [[MFWebSession alloc] initWithAttributes:(NSDictionary *)object] : nil;
}

@end