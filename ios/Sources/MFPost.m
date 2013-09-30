/* Copyright (c) 2013 Meep Factory OU */

#import "MFPost.h"
#import "NSDictionary+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_TITLE @"title"

@implementation MFPost

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_identifier = [attributes identifierForKey:KEY_IDENTIFIER];
        m_title = [attributes stringForKey:KEY_TITLE];
        m_status = kMFPostStatusListed;
        
        if(!m_identifier) {
            return nil;
        }
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        m_identifier, KEY_IDENTIFIER, nil];
}

@dynamic active;

- (BOOL)isActive
{
    return (m_status == kMFPostStatusListed) ? YES : NO;
}

@synthesize created = m_created;
@synthesize identifier = m_identifier;
@synthesize status = m_status;
@synthesize title = m_title;

- (BOOL)update:(NSDictionary *)changes
{
    return YES;
}

@end
