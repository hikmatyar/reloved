/* Copyright (c) 2013 Meep Factory OU */

#import "MFColor.h"
#import "NSDictionary+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_NAME @"name"

@implementation MFColor

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

- (id)initWithName:(NSString *)name
{
    self = [super init];
    
    if(self) {
        m_name = name;
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

- (NSComparisonResult)compare:(MFColor *)color
{
    return [m_name compare:color.name];
}

- (BOOL)isEqual:(MFColor *)color
{
    return ([m_identifier isEqualToString:color.identifier] && [m_name isEqualToString:color.name]) ? YES : NO;
}

- (NSString *)description
{
    return (m_name) ? m_name : [NSString stringWithFormat:@"<color:%@>", m_identifier];
}

@end
