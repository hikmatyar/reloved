/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormPickerField.h"
#import "MFFormPickerFieldDataSource.h"
#import "MFFormPickerFieldDelegate.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFFormPickerField

+ (CGFloat)preferredHeight
{
    return 50.0F;
}

@synthesize autohide = m_autohide;

@dynamic dataSource;

- (id <MFFormPickerFieldDataSource>)dataSource
{
    return m_dataSource;
}

- (void)setDataSource:(id<MFFormPickerFieldDataSource>)dataSource
{
    if(m_dataSource != dataSource) {
        m_dataSource = dataSource;
        
        if(self.window) {
            [self reloadData];
        }
    }
}

@synthesize delegate = m_delegate;

@dynamic font;

- (UIFont *)font
{
    return m_textField.font;
}

- (void)setFont:(UIFont *)font
{
    m_textField.font = font;
}

@dynamic inputAccessoryView;

- (UIView *)inputAccessoryView
{
    UITextField *textField = m_textField;
    UIView *inputAccessoryView;
    
    m_textField = nil;
    inputAccessoryView = textField.inputAccessoryView;
    m_textField = textField;
    
    return inputAccessoryView;
}

- (void)setInputAccessoryView:(UIView *)view
{
    m_textField.inputAccessoryView = view;
}

@dynamic selectedRow;

- (NSInteger)selectedRow
{
    return m_selectedRow;
}

- (void)setSelectedRow:(NSInteger)selectedRow
{
    if(m_selectedRow != selectedRow) {
        m_selectedRow = selectedRow;
        [m_pickerView selectRow:m_selectedRow inComponent:0 animated:NO];
    }
}

@dynamic textColor;

- (UIColor *)textColor
{
    return m_textField.textColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    m_textField.textColor = textColor;
}

- (void)reloadData
{
    [m_pickerView reloadAllComponents];
    [self setTitle:(m_selectedRow >= 0 && m_selectedRow < [m_dataSource numberOfRowsInPickerField:self]) ? [m_dataSource pickerField:self titleForRow:m_selectedRow] : @"" forState:UIControlStateNormal];
}

- (IBAction)show:(id)sender
{
    if([m_textField isFirstResponder]) {
        [m_textField resignFirstResponder];
    } else {
        [m_textField becomeFirstResponder];
    }
}

- (void)pickerViewTapped
{
    [self pickerView:m_pickerView didSelectRow:[m_pickerView selectedRowInComponent:0] inComponent:0];
    
    if(m_autohide) {
        [m_textField resignFirstResponder];
    }
}

#pragma mark MFFormButton

+ (BOOL)hasDisclosureIndicator
{
    return NO;
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([m_delegate respondsToSelector:@selector(pickerFieldDidBeginEditing:)]) {
        [m_delegate pickerFieldDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([m_delegate respondsToSelector:@selector(pickerFieldDidEndEditing:)]) {
        [m_delegate pickerFieldDidEndEditing:self];
    }
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [m_dataSource numberOfRowsInPickerField:self];
}

#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [m_dataSource pickerField:self titleForRow:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(m_selectedRow != row) {
        m_selectedRow = row;
        [self setTitle:[m_dataSource pickerField:self titleForRow:row] forState:UIControlStateNormal];
        
        if([m_delegate respondsToSelector:@selector(pickerField:didSelectRow:)]) {
            [m_delegate pickerField:self didSelectRow:row];
        }
    }
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 26.0F, round((frame.size.height - 7.0F) * 0.5F), 17.0F, 10.0F)];
        
        m_pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        m_pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        m_pickerView.dataSource = self;
        m_pickerView.delegate = self;
        m_pickerView.showsSelectionIndicator = YES;
        [m_pickerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapped)]];
        m_textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 1.0F, 1.0F)];
        m_textField.hidden = YES;
        m_textField.inputView = m_pickerView;
        m_textField.delegate = self;
        
        
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        imageView.image = [UIImage imageNamed:@"Picker-Arrow.png"];
        [self addSubview:imageView];
        
        [self addSubview:m_textField];
        [self addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)didMoveToWindow
{
    if(self.window) {
        [self setTitle:(m_selectedRow >= 0 && m_selectedRow < [m_dataSource numberOfRowsInPickerField:self]) ? [m_dataSource pickerField:self titleForRow:m_selectedRow] : @"" forState:UIControlStateNormal];
    }
    
    [super didMoveToWindow];
}

#pragma mark UIResponder

- (BOOL)canBecomeFirstResponder
{
    return [m_textField canBecomeFirstResponder];
}

- (BOOL)isFirstResponder
{
    return [m_textField isFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    return [m_textField becomeFirstResponder];
}

- (BOOL)canResignFirstResponder
{
    return [m_textField canResignFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [m_textField resignFirstResponder];
}

@end
