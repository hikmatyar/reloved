/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFFormPickerField;

@protocol MFFormPickerFieldDelegate <NSObject>

@optional

- (void)pickerFieldDidBeginEditing:(MFFormPickerField *)pickerField;
- (void)pickerFieldDidEndEditing:(MFFormPickerField *)pickerField;
- (void)pickerField:(MFFormPickerField *)pickerField didSelectRow:(NSInteger)row;

@end
