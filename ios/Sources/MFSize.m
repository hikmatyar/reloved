/* Copyright (c) 2013 Meep Factory OU */

#import "MFSize.h"
#import "NSDictionary+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_NAME @"name"

@implementation MFSize

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_identifier = [attributes identifierForKey:KEY_IDENTIFIER];
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
    return [NSDictionary dictionaryWithObjectsAndKeys:m_identifier, KEY_IDENTIFIER, m_name, KEY_NAME, nil];
}

@synthesize name = m_name;
@synthesize identifier = m_identifier;

#pragma mark NSObject

- (NSComparisonResult)compare:(MFSize *)size
{
    NSInteger l1 = m_name.length;
    NSInteger l2 = size.name.length;
    
    if(l1 < l2) {
        return NSOrderedAscending;
    } else if(l1 > l2) {
        return NSOrderedDescending;
    }
    
    return [m_name compare:size.name];
}

- (BOOL)isEqual:(MFSize *)size
{
    return ([m_identifier isEqualToString:size.identifier] && [m_name isEqualToString:size.name]) ? YES : NO;
}

@end
