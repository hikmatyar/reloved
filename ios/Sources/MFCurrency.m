/* Copyright (c) 2013 Meep Factory OU */

#import "MFCurrency.h"
#import "NSDictionary+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_CODE @"code"
#define KEY_COUNTRY @"country"

@implementation MFCurrency

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_identifier = [attributes identifierForKey:KEY_IDENTIFIER];
        m_code = [attributes stringForKey:KEY_CODE];
        m_country = [attributes stringForKey:KEY_COUNTRY];
        m_fallback = [m_identifier isEqualToString:@"*"];
        
        if(!m_identifier || !m_country) {
            return nil;
        }
    }
    
    return self;
}

- (id)initWithIdentifier:(NSString *)identifier code:(NSString *)code country:(NSString *)country fallback:(BOOL)fallback
{
    self = [super init];
    
    if(self) {
        m_identifier = identifier;
        m_code = code;
        m_country = country;
        m_fallback = fallback;
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    return [NSDictionary dictionaryWithObjectsAndKeys:m_identifier, KEY_IDENTIFIER, m_country, KEY_COUNTRY, m_code, KEY_CODE, nil];
}

@synthesize code = m_code;
@synthesize country = m_country;
@synthesize fallback = m_fallback;
@synthesize identifier = m_identifier;

- (NSComparisonResult)compare:(MFCurrency *)currency
{
    return [m_identifier compare:currency.identifier];
}

#pragma mark NSObject

- (BOOL)isEqual:(MFCurrency *)currency
{
    return ([m_identifier isEqualToString:currency.identifier] && [m_country isEqualToString:currency.country] && [m_code isEqualToString:currency.code]) ? YES : NO;
}

@end