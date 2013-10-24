/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFDelivery;

extern NSString *MFDatabaseDidChangeDeliveriesNotification;

@interface MFDatabase(Delivery)

@property (nonatomic, copy) NSArray *deliveries;
- (MFDelivery *)deliveryForIdentifier:(NSString *)identifier;
- (MFDelivery *)deliveryForCountryId:(NSString *)countryId;

@end
