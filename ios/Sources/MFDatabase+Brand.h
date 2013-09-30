/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFBrand;

extern NSString *MFDatabaseDidChangeBrandsNotification;

@interface MFDatabase(Brand)

@property (nonatomic, copy) NSArray *brands;

@end
