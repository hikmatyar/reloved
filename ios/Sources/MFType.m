/* Copyright (c) 2013 Meep Factory OU */

#import "MFType.h"
#import "NSDictionary+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_NAME @"name"

@implementation MFType

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

- (BOOL)isEqual:(MFType *)type
{
    return ([m_identifier isEqualToString:type.identifier] && [m_name isEqualToString:type.name]) ? YES : NO;
}

@end
