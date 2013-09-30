/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFCountry;

extern NSString *MFDatabaseDidChangeCountriesNotification;

@interface MFDatabase(Country)

@property (nonatomic, copy) NSArray *countries;

@end
