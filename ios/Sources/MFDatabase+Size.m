/* Copyright (c) 2013 Meep Factory OU */

#import "JSONKit.h"
#import "MFDatabase+Size.h"
#import "MFSize.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangeSizesNotification = @"MFDatabaseDidChangeSizes";

#define TABLE_SIZES @"sizes"

@implementation MFDatabase(Size)

@dynamic sizes;

- (NSArray *)sizes
{
    NSArray *s_sizes = [m_state objectForKey:TABLE_SIZES];
    
    if(!s_sizes) {
        NSMutableArray *sizes = [[NSMutableArray alloc] init];
        
        for(MFSize *size in [m_store allObjectsInTable:TABLE_SIZES usingBlock:^id (NSString *key, NSData *value) {
            return [[MFSize alloc] initWithAttributes:[value objectFromJSONData]];
        }].objectEnumerator) {
            [sizes addObject:size];
        }
        
        [m_state setObject:sizes forKey:TABLE_SIZES];
        s_sizes = sizes;
    }
    
    return s_sizes;
}

- (void)setSizes:(NSArray *)sizes
{
    if(!sizes || [m_state objectForKey:TABLE_SIZES] != sizes) {
        [m_state setValue:sizes forKey:TABLE_SIZES];
        [m_store removeAllObjectsInTable:TABLE_SIZES];
        
        for(MFSize *size in sizes) {
            [m_store setObject:[size.attributes JSONData] forKey:size.identifier inTable:TABLE_SIZES];
        }
        
        [self addUpdate:MFDatabaseDidChangeSizesNotification change:nil];
    }
}

@end
