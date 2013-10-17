/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormButton.h"

@protocol MFFormPickerFieldDataSource, MFFormPickerFieldDelegate;

@interface MFFormPickerField : MFFormButton <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    @private
    BOOL m_autohide;
    __unsafe_unretained id <MFFormPickerFieldDataSource> m_dataSource;
    __unsafe_unretained id <MFFormPickerFieldDelegate> m_delegate;
    NSInteger m_selectedRow;
    UIPickerView *m_pickerView;
    UITextField *m_textField;
}

@property (nonatomic, assign) BOOL autohide;
@property (nonatomic, assign) id <MFFormPickerFieldDataSource> dataSource;
@property (nonatomic, assign) id <MFFormPickerFieldDelegate> delegate;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIView *inputAccessoryView;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, retain) UIColor *textColor;

- (void)reloadData;

@end
