/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFOptionPickerController;

@protocol MFOptionPickerControllerDelegate <NSObject>

@optional

- (BOOL)optionPickerController:(MFOptionPickerController *)controller mustSelectItem:(id)item;
- (void)optionPickerControllerDidChange:(MFOptionPickerController *)controller atItem:(id)item;
- (void)optionPickerControllerDidClose:(MFOptionPickerController *)controller;
- (void)optionPickerControllerDidComplete:(MFOptionPickerController *)controller;

@end
