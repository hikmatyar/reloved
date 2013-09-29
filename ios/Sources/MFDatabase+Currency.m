/* Copyright (c) 2013 Meep Factory OU */

#import "MFCurrency.h"
#import "MFDatabase+Currency.h"

NSString *MFDatabaseDidChangeCurrenciesNotification = @"MFDatabaseDidChangeCurrencies";

@implementation MFDatabase(Currency)

@dynamic currencies;

- (NSArray *)currencies
{
    return nil;
}

- (void)setCurrencies:(NSArray *)currencies
{
}

- (MFCurrency *)currencyForCountry:(NSString *)country
{
    return nil;
}

@end
