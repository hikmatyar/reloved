/* Copyright (c) 2013 Meep Factory OU */

#import "MFPost.h"

@implementation MFPost

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        
    }
    
    return self;
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
    return NO;
}

@end
