/* Copyright (c) 2013 Meep Factory OU */

#import "MFCountry.h"
#import "NSDictionary+Additions.h"

#define KEY_CODE @"code"
#define KEY_IDENTIFIER @"id"
#define KEY_NAME @"name"

@implementation MFCountry

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_identifier = [attributes identifierForKey:KEY_IDENTIFIER];
        m_code = [attributes stringForKey:KEY_CODE];
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
    return [NSDictionary dictionaryWithObjectsAndKeys:m_identifier, KEY_IDENTIFIER, m_name, KEY_NAME, m_code, KEY_CODE, nil];
}

@synthesize code = m_code;
@synthesize name = m_name;
@synthesize identifier = m_identifier;

#pragma mark NSObject

- (BOOL)isEqual:(MFCountry *)country
{
    return ([m_identifier isEqualToString:country.identifier] && [m_name isEqualToString:country.name] && [m_code isEqualToString:country.code]) ? YES : NO;
}

@end
