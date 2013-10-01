/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFOptionPickerController;

@protocol MFOptionPickerControllerDelegate <NSObject>

@optional

- (void)optionPickerControllerDidChange:(MFOptionPickerController *)controller;
- (void)optionPickerControllerDidComplete:(MFOptionPickerController *)controller;

@end
