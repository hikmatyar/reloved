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
    return [NSDictionary dictionaryWithObjectsAndKeys:m_identifier, KEY_IDENTIFIER, m_name, KEY_NAME, m_code, KEY_CODE, nil];
}

@synthesize code = m_code;
@synthesize name = m_name;
@synthesize identifier = m_identifier;

#pragma mark NSObject

- (NSComparisonResult)compare:(MFCountry *)country
{
    // TODO: Maybe use preferred country from NSLocale object?
    NSInteger gb1 = ([m_code isEqualToString:@"gb"]) ? 1 : 0;
    NSInteger gb2 = ([country.code isEqualToString:@"gb"]) ? 1 : 0;
    
    return (gb1 > gb2) ? NSOrderedAscending : ((gb1 < gb2) ? NSOrderedDescending : [m_name compare:country.name]);
}

- (BOOL)isEqual:(MFCountry *)country
{
    return (MFEqual(m_identifier, country.identifier) && MFEqual(m_name, country.name) && MFEqual(m_code, country.code)) ? YES : NO;
}

@end
