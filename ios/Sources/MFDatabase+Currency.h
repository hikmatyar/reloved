/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFCurrency;

extern NSString *MFDatabaseDidChangeCurrenciesNotification;

@interface MFDatabase(Currency)

@property (nonatomic, copy) NSArray *currencies;
- (MFCurrency *)currencyForCountry:(NSString *)country;

@end
