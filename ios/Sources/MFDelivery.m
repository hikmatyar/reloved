/* Copyright (c) 2013 Meep Factory OU */

#import "MFDelivery.h"
#import "NSDictionary+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_NAME @"name"
#define KEY_PRICE @"price"
#define KEY_COUNTRY @"country"
#define KEY_CURRENCY @"currency"

@implementation MFDelivery

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_identifier = [attributes identifierForKey:KEY_IDENTIFIER];
        m_name = [attributes stringForKey:KEY_NAME];
        m_price = [attributes integerForKey:KEY_PRICE];
        m_countryId = [attributes stringForKey:KEY_COUNTRY];
        m_currency = [attributes stringForKey:KEY_CURRENCY];
        
        if(!m_identifier || !m_name || !m_currency) {
            return nil;
        }
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        m_identifier, KEY_IDENTIFIER,
        m_name, KEY_NAME,
        m_currency, KEY_CURRENCY,
        [NSNumber numberWithInteger:m_price], KEY_PRICE,
        m_countryId, KEY_COUNTRY, nil];
}

@synthesize name = m_name;
@synthesize identifier = m_identifier;
@synthesize price = m_price;
@synthesize currency = m_currency;
@synthesize countryId = m_countryId;

#pragma mark NSObject

- (BOOL)isEqual:(MFDelivery *)delivery
{
    return ([m_identifier isEqualToString:delivery.identifier] &&
            [m_name isEqualToString:delivery.name] &&
            [m_currency isEqualToString:delivery.currency] &&
            m_price == delivery.price &&
            MFEqual(m_countryId, delivery.countryId)) ? YES : NO;
}

@end
