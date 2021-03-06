/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFSize;

extern NSString *MFDatabaseDidChangeSizesNotification;

@interface MFDatabase(Size)

@property (nonatomic, copy) NSArray *sizes;
- (MFSize *)sizeForIdentifier:(NSString *)identifier;

@end
