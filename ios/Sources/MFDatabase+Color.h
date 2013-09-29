/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFColor;

extern NSString *MFDatabaseDidChangeColorsNotification;

@interface MFDatabase(Color)

@property (nonatomic, copy) NSArray *colors;

@end
