/* Copyright (c) 2013 Meep Factory OU */

#import "JSONKit.h"
#import "MFCountry.h"
#import "MFDatabase+Country.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangeCountriesNotification = @"MFDatabaseDidChangeCountries";

#define TABLE_COUNTRIES @"countries"

@implementation MFDatabase(Country)

@dynamic countries;

- (NSArray *)countries
{
    NSArray *s_countries = [m_state objectForKey:TABLE_COUNTRIES];
    
    if(!s_countries) {
        NSMutableArray *countries = [[NSMutableArray alloc] init];
        
        for(MFCountry *country in [m_store allObjectsInTable:TABLE_COUNTRIES usingBlock:^id (NSString *key, NSData *value) {
            return [[MFCountry alloc] initWithAttributes:[value objectFromJSONData]];
        }].objectEnumerator) {
            [countries addObject:country];
        }
        
        [m_state setObject:countries forKey:TABLE_COUNTRIES];
        s_countries = countries;
    }
    
    return s_countries;
}

- (void)setCountries:(NSArray *)countries
{
    if(!countries || [m_state objectForKey:TABLE_COUNTRIES] != countries) {
        [m_state setValue:countries forKey:TABLE_COUNTRIES];
        [m_store removeAllObjectsInTable:TABLE_COUNTRIES];
        
        for(MFCountry *country in countries) {
            [m_store setObject:[country.attributes JSONData] forKey:country.identifier inTable:TABLE_COUNTRIES];
        }
        
        [self addUpdate:MFDatabaseDidChangeCountriesNotification change:nil];
    }
}

@end