/* Copyright (c) 2013 Meep Factory OU */

#import "JSONKit.h"
#import "MFCurrency.h"
#import "MFDatabase+Currency.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangeCurrenciesNotification = @"MFDatabaseDidChangeCurrencies";

#define TABLE_CURRENCIES @"currencies"

@implementation MFDatabase(Currency)

@dynamic currencies;

- (NSArray *)currencies
{
    NSArray *s_currencies = [m_state objectForKey:TABLE_CURRENCIES];
    
    if(!s_currencies) {
        NSMutableArray *currencies = [[NSMutableArray alloc] init];
        
        for(MFCurrency *currency in [m_store allObjectsInTable:TABLE_CURRENCIES usingBlock:^id (NSString *key, NSData *value) {
            return [[MFCurrency alloc] initWithAttributes:[value objectFromJSONData]];
        }].objectEnumerator) {
            [currencies addObject:currency];
        }
        
        [m_state setObject:currencies forKey:TABLE_CURRENCIES];
        s_currencies = currencies;
    }
    
    return s_currencies;
}

- (void)setCurrencies:(NSArray *)currencies
{
    if(!currencies || [m_state objectForKey:TABLE_CURRENCIES] != currencies) {
        [m_state setValue:currencies forKey:TABLE_CURRENCIES];
        [m_store removeAllObjectsInTable:TABLE_CURRENCIES];
        
        for(MFCurrency *currency in currencies) {
            [m_store setObject:[currency.attributes JSONData] forKey:currency.identifier inTable:TABLE_CURRENCIES];
        }
        
        [self addUpdate:MFDatabaseDidChangeCurrenciesNotification change:nil];
    }
}

- (MFCurrency *)currencyForCountry:(NSString *)country
{
    MFCurrency *fallback = nil;
    
    for(MFCurrency *currency in self.currencies) {
        if([country isEqualToString:currency.country]) {
            return currency;
        }
        
        if(!fallback && currency.fallback) {
            fallback = currency;
        }
    }
    
    return fallback;
}

@end
