/* Copyright (c) 2013 Meep Factory OU */

#import "JSONKit.h"
#import "MFDatabase+Delivery.h"
#import "MFDelivery.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangeDeliveriesNotification = @"MFDatabaseDidChangeDeliveries";

#define TABLE_DELIVERIES @"deliveries"

@implementation MFDatabase(Delivery)

@dynamic deliveries;

- (NSArray *)deliveries
{
    NSArray *s_deliveries = [m_state objectForKey:TABLE_DELIVERIES];
    
    if(!s_deliveries) {
        NSMutableArray *deliveries = [[NSMutableArray alloc] init];
        
        for(MFDelivery *delivery in [m_store allObjectsInTable:TABLE_DELIVERIES usingBlock:^id (NSString *key, NSData *value) {
            return [[MFDelivery alloc] initWithAttributes:[value objectFromJSONData]];
        }].objectEnumerator) {
            [deliveries addObject:delivery];
        }
        
        [m_state setObject:deliveries forKey:TABLE_DELIVERIES];
        s_deliveries = deliveries;
    }
    
    return s_deliveries;
}

- (void)setDeliveries:(NSArray *)deliveries
{
    if(!deliveries || [m_state objectForKey:TABLE_DELIVERIES] != deliveries) {
        [m_state setValue:deliveries forKey:TABLE_DELIVERIES];
        [m_store removeAllObjectsInTable:TABLE_DELIVERIES];
        
        for(MFDelivery *delivery in deliveries) {
            [m_store setObject:[delivery.attributes JSONData] forKey:delivery.identifier inTable:TABLE_DELIVERIES];
        }
        
        [self addUpdate:MFDatabaseDidChangeDeliveriesNotification change:nil];
    }
}

@end