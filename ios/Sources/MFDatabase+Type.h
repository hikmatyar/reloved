/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFType;

extern NSString *MFDatabaseDidChangeTypesNotification;

@interface MFDatabase(Type)

@property (nonatomic, copy) NSArray *types;

@end
