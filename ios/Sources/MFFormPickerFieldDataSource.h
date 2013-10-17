/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFFormPickerField;

@protocol MFFormPickerFieldDataSource <NSObject>

@required

- (NSInteger)numberOfRowsInPickerField:(MFFormPickerField *)pickerField;
- (NSString *)pickerField:(MFFormPickerField *)pickerField titleForRow:(NSInteger)row;

@end
