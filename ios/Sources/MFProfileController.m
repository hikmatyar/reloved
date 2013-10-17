/* Copyright (c) 2013 Meep Factory OU */

#import "MFCountry.h"
#import "MFDatabase+Country.h"
#import "MFForm.h"
#import "MFFormAccessory.h"
#import "MFFormButton.h"
#import "MFFormFooter.h"
#import "MFFormLabel.h"
#import "MFFormPickerField.h"
#import "MFFormTextField.h"
#import "MFFormTextView.h"
#import "MFProfileController.h"
#import "UIColor+Additions.h"

#define TAG_FORM 1000

@implementation MFProfileController

- (MFForm *)form
{
    return (MFForm *)[self.view viewWithTag:TAG_FORM];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)done:(id)sender
{
}

#pragma mark MFFormPickerFieldDataSource

- (NSInteger)numberOfRowsInPickerField:(MFFormPickerField *)pickerField
{
    return m_countries.count;
}

- (NSString *)pickerField:(MFFormPickerField *)pickerField titleForRow:(NSInteger)row
{
    return ((MFCountry *)[m_countries objectAtIndex:row]).name;
}

#pragma mark MFFormPickerFieldDelegate

- (void)pickerFieldDidBeginEditing:(MFFormPickerField *)pickerField
{
    [self.form scrollToView:pickerField animated:YES];
    [m_accessory invalidate];
}

- (void)pickerField:(MFFormPickerField *)pickerField didSelectRow:(NSInteger)row
{
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.form scrollToView:textField animated:YES];
    [m_accessory invalidate];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    } else {
        [m_accessory selectNext];
    }
    
    return YES;
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.form scrollToView:textView animated:YES];
    [m_accessory invalidate];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
}

#pragma mark UIViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    MFForm *form = [[MFForm alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    NSMutableArray *fields = [NSMutableArray array];
    MFFormPickerField *pickerField;
    MFFormTextField *textField;
    MFFormTextView *textView;
    MFFormFooter *footer;
    MFFormLabel *label;
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.FullName", nil);
    [form addSubview:label];
    
    textField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyNext;
    textField.placeholder = NSLocalizedString(@"Profile.Hint.FullName", nil);
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [form addSubview:textField];
    [fields addObject:textField];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.AddressLine", nil);
    [form addSubview:label];
    
    textView = [[MFFormTextView alloc] initWithFrame:CGRectMake(10.0F, 220.0F, 300.0F, 2.0F * [MFFormLabel preferredHeight])];
    textView.delegate = self;
    textView.placeholder = NSLocalizedString(@"Profile.Hint.AddressLine", nil);
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    [form addSubview:textView];
    [fields addObject:textView];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.Country", nil);
    [form addSubview:label];
    
    pickerField = [[MFFormPickerField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormPickerField preferredHeight])];
    pickerField.dataSource = self;
    pickerField.delegate = self;
    pickerField.placeholder =NSLocalizedString(@"Profile.Hint.Country", nil);
    [form addSubview:pickerField];
    [fields addObject:pickerField];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.City", nil);
    [form addSubview:label];
    
    textField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyNext;
    textField.placeholder = NSLocalizedString(@"Profile.Hint.City", nil);
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [form addSubview:textField];
    [fields addObject:textField];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.Postcode", nil);
    [form addSubview:label];
    
    textField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyNext;
    textField.placeholder = NSLocalizedString(@"Profile.Hint.Postcode", nil);
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [form addSubview:textField];
    [fields addObject:textField];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.Phone", nil);
    [form addSubview:label];
    
    textField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyNext;
    textField.placeholder = NSLocalizedString(@"Profile.Hint.Phone", nil);
    textField.keyboardType = UIKeyboardTypePhonePad;
    [form addSubview:textField];
    [fields addObject:textField];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.Email", nil);
    [form addSubview:label];
    
    textField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.placeholder = NSLocalizedString(@"Profile.Hint.Email", nil);
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [form addSubview:textField];
    [fields addObject:textField];
    
    footer = [[MFFormFooter alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormFooter preferredHeight])];
    footer.lineBreakMode = NSLineBreakByWordWrapping;
    footer.text = NSLocalizedString(@"Profile.Hint.Footer", nil);
    [footer sizeToFit];
    [form addSubview:footer];
    
    form.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    form.tag = TAG_FORM;
    [view addSubview:form];
    
    view.backgroundColor = [UIColor themeBackgroundColor];
    self.view = view;
    
    [m_accessory deactivate];
    m_accessory = [[MFFormAccessory alloc] initWithContext:form];
    m_accessory.fields = fields;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [m_accessory activate];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [m_accessory deactivate];
    [super viewWillDisappear:animated];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        NSArray *countries = [[MFDatabase sharedDatabase].countries sortedArrayUsingSelector:@selector(compare:)];
        
        m_countries = [[NSMutableArray alloc] init];
        
        if(countries) {
            [(NSMutableArray *)m_countries addObjectsFromArray:countries];
        }
        
        [(NSMutableArray *)m_countries insertObject:[[MFCountry alloc] initWithName:NSLocalizedString(@"Profile.Hint.Country", nil)] atIndex:0];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profile.Action.Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profile.Action.Done", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
        self.title = NSLocalizedString(@"Profile.Title", nil);
    }
    
    return self;
}

@end
