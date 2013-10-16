/* Copyright (c) 2013 Meep Factory OU */

#import "MFUser.h"
#import "NSDate+Additions.h"
#import "NSDictionary+Additions.h"
#import "NSString+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_MEDIA @"media"
#define KEY_NAME @"name"
#define KEY_DATE @"date"

@implementation MFUser

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_identifier = [attributes identifierForKey:KEY_IDENTIFIER];
        m_date = [attributes stringForKey:KEY_DATE].datetimeValue;
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
    return [NSDictionary dictionaryWithObjectsAndKeys:
        m_identifier, KEY_IDENTIFIER,
        m_name, KEY_NAME,
        (m_media) ? m_media : [NSNull null],
        KEY_MEDIA, m_date.datetimeString, KEY_DATE, nil];
}

@synthesize date = m_date;
@synthesize name = m_name;
@synthesize media = m_media;
@synthesize identifier = m_identifier;

#pragma mark NSObject

- (BOOL)isEqual:(MFUser *)user
{
    return ([m_identifier isEqualToString:user.identifier] && [m_name isEqualToString:user.name] && MFEqual(m_media, user.media)) ? YES : NO;
}

@end
