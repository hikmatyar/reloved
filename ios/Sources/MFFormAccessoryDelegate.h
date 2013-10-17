/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFFormAccessory;

@protocol MFFormAccessoryDelegate <NSObject>

@optional

- (void)accessoryDidTapPrev:(MFFormAccessory *)accessory;
- (void)accessoryDidTapNext:(MFFormAccessory *)accessory;
- (void)accessoryDidTapDone:(MFFormAccessory *)accessory;

@end
