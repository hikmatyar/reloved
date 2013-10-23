/* Copyright (c) 2013 Meep Factory OU */

#import "MFNotice.h"
#import "MFOrder.h"
#import "NSDate+Additions.h"
#import "NSDictionary+Additions.h"
#import "NSString+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_DATE @"date"
#define KEY_POSTS @"posts"
#define KEY_STATUS @"status"
#define KEY_NOTICE @"notice"

@implementation MFOrder

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_identifier = [attributes identifierForKey:KEY_IDENTIFIER];
        m_status = [attributes integerForKey:KEY_STATUS];
        m_postIds = [attributes arrayOfIdentifiersForKey:KEY_POSTS];
        m_date = [attributes stringForKey:KEY_DATE].datetimeValue;
        m_notice = [[MFNotice alloc] initWithAttributes:[attributes dictionaryForKey:KEY_NOTICE]];
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setValue:m_identifier forKey:KEY_IDENTIFIER];
    [attributes setValue:[NSNumber numberWithInteger:m_status] forKey:KEY_STATUS];
    [attributes setValue:m_postIds forKey:KEY_POSTS];
    [attributes setValue:m_date.datetimeString forKey:KEY_DATE];
    [attributes setValue:m_notice.attributes forKey:KEY_NOTICE];
    
    return attributes;
}

@synthesize identifier = m_identifier;
@synthesize date = m_date;
@synthesize postIds = m_postIds;
@synthesize status = m_status;
@synthesize notice = m_notice;

#pragma mark MFWebRequestTransform

+ (id)parseFromObject:(id)object
{
    return ([object isKindOfClass:[NSDictionary class]]) ? [[self alloc] initWithAttributes:(NSDictionary *)object] : nil;
}

@end
