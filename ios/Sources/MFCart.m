/* Copyright (c) 2013 Meep Factory OU */

#import "MFCart.h"

@implementation MFCart

@dynamic attributes;

- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    
    
    return attributes;
}

@synthesize postIds = m_postIds;

@end

#pragma mark -

@implementation MFMutableCart

- (void)setPostIds:(NSArray *)postIds
{
    m_postIds = postIds;
}

@end