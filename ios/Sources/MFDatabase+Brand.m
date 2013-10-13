/* Copyright (c) 2013 Meep Factory OU */

#import "JSONKit.h"
#import "MFBrand.h"
#import "MFDatabase+Brand.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangeBrandsNotification = @"MFDatabaseDidChangeBrands";

#define TABLE_BRANDS @"brands"

@implementation MFDatabase(Brand)

@dynamic brands;

- (NSArray *)brands
{
    NSArray *s_brands = [m_state objectForKey:TABLE_BRANDS];
    
    if(!s_brands) {
        NSMutableArray *brands = [[NSMutableArray alloc] init];
        
        for(MFBrand *brand in [m_store allObjectsInTable:TABLE_BRANDS usingBlock:^id (NSString *key, NSData *value) {
            return [[MFBrand alloc] initWithAttributes:[value objectFromJSONData]];
        }].objectEnumerator) {
            [brands addObject:brand];
        }
        
        [m_state setObject:brands forKey:TABLE_BRANDS];
        s_brands = brands;
    }
    
    return s_brands;
}

- (void)setBrands:(NSArray *)brands
{
    if(!brands || [m_state objectForKey:TABLE_BRANDS] != brands) {
        [m_state setValue:brands forKey:TABLE_BRANDS];
        [m_store removeAllObjectsInTable:TABLE_BRANDS];
        
        for(MFBrand *brand in brands) {
            [m_store setObject:[brand.attributes JSONData] forKey:brand.identifier inTable:TABLE_BRANDS];
        }
        
        [self addUpdate:MFDatabaseDidChangeBrandsNotification change:nil];
    }
}

- (MFBrand *)brandForIdentifier:(NSString *)identifier
{
    for(MFBrand *brand in self.brands) {
        if([identifier isEqualToString:brand.identifier]) {
            return brand;
        }
    }
    
    return nil;
}

@end