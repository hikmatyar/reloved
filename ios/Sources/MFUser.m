/* Copyright (c) 2013 Meep Factory OU */

#import "MFUser.h"
#import "NSDictionary+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_MEDIA @"media"
#define KEY_NAME @"name"

@implementation MFUser

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_identifier = [attributes identifierForKey:KEY_IDENTIFIER];
        m_media = [attributes identifierForKey:KEY_MEDIA];
        m_name = [attributes stringForKey:KEY_NAME];
        
        if(!m_identifier || !m_name) {
            return nil;
        }
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    return [NSDictionary dictionaryWithObjectsAndKeys:m_identifier, KEY_IDENTIFIER, m_name, KEY_NAME, m_media, KEY_MEDIA, nil];
}

@synthesize name = m_name;
@synthesize media = m_media;
@synthesize identifier = m_identifier;

#pragma mark NSObject

- (BOOL)isEqual:(MFUser *)user
{
    return ([m_identifier isEqualToString:user.identifier] && [m_name isEqualToString:user.name] && MFEqual(m_media, user.media)) ? YES : NO;
}

@end
