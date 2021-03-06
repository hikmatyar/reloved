/* Copyright (c) 2013 Meep Factory OU */

#import "MFEvent.h"
#import "NSDate+Additions.h"
#import "NSDictionary+Additions.h"
#import "NSString+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_MEDIA @"media"
#define KEY_DATE @"date"
#define KEY_LINK @"link"
#define KEY_META @"meta"
#define KEY_TYPE @"type"

@implementation MFEvent

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_identifier = [attributes identifierForKey:KEY_IDENTIFIER];
        m_mediaId = [attributes identifierForKey:KEY_MEDIA];
        m_type = [attributes integerForKey:KEY_TYPE];
        m_link = [attributes stringForKey:KEY_LINK];
        m_meta = [attributes arrayForKey:KEY_META];
        m_date = [attributes stringForKey:KEY_DATE].datetimeValue;
        
        if(!m_identifier || !m_date) {
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
        [NSNumber numberWithInteger:m_type], KEY_TYPE,
        m_date.datetimeString, KEY_DATE,
        (m_meta) ? m_meta : [NSNull null], KEY_META,
        (m_mediaId) ? m_mediaId : [NSNull null], KEY_MEDIA,
        m_link, KEY_LINK, nil];
}

@synthesize date = m_date;
@synthesize identifier = m_identifier;
@synthesize mediaId = m_mediaId;
@synthesize link = m_link;
@synthesize meta = m_meta;
@synthesize type = m_type;

#pragma mark NSObject

- (BOOL)isEqual:(MFEvent *)event
{
    return [event.identifier isEqualToString:m_identifier];
}

@end
