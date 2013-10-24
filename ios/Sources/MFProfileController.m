/* Copyright (c) 2013 Meep Factory OU */

#import "MBProgressHUD.h"
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
#import "MFUserDetails.h"
#import "MFWebService+User.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define ALERT_FORM 2000
#define ALERT_LOAD 2001
#define ALERT_SAVE 2002
#define TAG_FORM 1000
#define TAG_FIELD_EMAIL 4000
#define TAG_FIELD_PHONE 4001
#define TAG_FIELD_FULLNAME 4002
#define TAG_FIELD_COUNTRY 4003
#define TAG_FIELD_CITY 4004
#define TAG_FIELD_ADDRESS 4005
#define TAG_FIELD_ZIPCODE 4006

@implementation MFProfileController

- (MFForm *)form
{
    return (MFForm *)[self.view viewWithTag:TAG_FORM];
}

- (MFFormTextField *)fullNameField
{
    return (MFFormTextField *)[self.view viewWithTag:TAG_FIELD_FULLNAME];
}

- (MFFormTextField *)cityField
{
    return (MFFormTextField *)[self.view viewWithTag:TAG_FIELD_CITY];
}

- (MFFormTextView *)addressField
{
    return (MFFormTextView *)[self.view viewWithTag:TAG_FIELD_ADDRESS];
}

- (MFFormPickerField *)countryField
{
    return (MFFormPickerField *)[self.view viewWithTag:TAG_FIELD_COUNTRY];
}

- (MFFormTextField *)emailField
{
    return (MFFormTextField *)[self.view viewWithTag:TAG_FIELD_EMAIL];
}

- (MFFormTextField *)phoneField
{
    return (MFFormTextField *)[self.view viewWithTag:TAG_FIELD_PHONE];
}

- (MFFormTextField *)zipcodeField
{
    return (MFFormTextField *)[self.view viewWithTag:TAG_FIELD_ZIPCODE];
}

- (void)invalidate
{
    if(m_details) {
        NSString *countryId = m_details.countryId;
        
        self.emailField.text = m_details.email;
        self.phoneField.text = m_details.phone;
        self.fullNameField.text = m_details.fullName;
        self.cityField.text = m_details.city;
        self.addressField.text = m_details.address;
        self.zipcodeField.text = m_details.zipcode;
        
        if(countryId) {
            for(NSInteger i = 0, c = m_countries.count; i < c; i++) {
                MFCountry *country = [m_countries objectAtIndex:i];
                
                if([country.identifier isEqualToString:countryId]) {
                    self.countryField.selectedRow = i;
                    break;
                }
            }
        } else {
            self.countryField.selectedRow = 0;
        }
        
        self.form.hidden = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [m_hud hide:NO];
        m_hud = nil;
    } else {
        self.form.hidden = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        if(!m_hud) {
            m_hud = [[MBProgressHUD alloc] initWithView:self.view];
            m_hud.dimBackground = YES;
            m_hud.labelText = NSLocalizedString(@"Profile.Label.Loading", nil);
            m_hud.labelFont = [UIFont themeBoldFontOfSize:16.0F];
            m_hud.detailsLabelFont = [UIFont themeBoldFontOfSize:12.0F];
            m_hud.removeFromSuperViewOnHide = YES;
            [self.view addSubview:m_hud];
            [m_hud show:NO];
        }
    }
}

- (void)loadData
{
    [[MFWebService sharedService] requestUserDetails:nil target:self usingBlock:^(id target, NSError *error, MFUserDetails *details) {
        if(error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Profile.Alert.LoadError.Title", nil)
                                                                message:NSLocalizedString(@"Profile.Alert.LoadError.Message", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Profile.Alert.LoadError.Action.Close", nil)
                                                      otherButtonTitles:NSLocalizedString(@"Profile.Alert.LoadError.Action.Retry", nil), nil];
            
            alertView.tag = ALERT_LOAD;
            [alertView show];
        } else {
            m_details = details;
            [self invalidate];
        }
    }];
}

- (void)saveData:(MFUserDetails *)details
{
    [[MFWebService sharedService] requestUserEdit:details target:self usingBlock:^(id target, NSError *error, id result) {
        if(error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Profile.Alert.SaveError.Title", nil)
                                                                message:NSLocalizedString(@"Profile.Alert.SaveError.Message", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Profile.Alert.SaveError.Action.Close", nil)
                                                      otherButtonTitles:NSLocalizedString(@"Profile.Alert.SaveError.Action.Retry", nil), nil];
            
            alertView.tag = ALERT_SAVE;
            [alertView show];
        } else {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }];
}

- (IBAction)cancel:(id)sender
{
    [[MFWebService sharedService] cancelRequestsForTarget:self];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)done:(id)sender
{
    MFMutableUserDetails *details = [[MFMutableUserDetails alloc] init];
    NSString *email = self.emailField.text.stringByTrimmingWhitespace;
    NSString *phone = self.phoneField.text.stringByTrimmingWhitespace;
    NSArray *fullName = [self.fullNameField.text.stringByTrimmingWhitespace componentsSeparatedByString:@" "];
    NSString *firstName = fullName.firstObject;
    NSString *lastName = (fullName.count > 1) ? [[fullName subarrayWithRange:NSMakeRange(1, fullName.count - 1)] componentsJoinedByString:@" "] : @"";
    NSString *countryId = ((MFCountry *)self.countryField.selectedData).identifier;
    NSString *city = self.cityField.text.stringByTrimmingWhitespace;
    NSString *address = self.addressField.text.stringByTrimmingWhitespace;
    NSString *zipcode = self.zipcodeField.text.stringByTrimmingWhitespace;
    NSString *error = nil;
    
    // Form validation
    if(firstName.length == 0) {
        error = NSLocalizedString(@"Profile.Label.FullName", nil);
    } else if(email.length == 0) {
        error = NSLocalizedString(@"Profile.Label.Email", nil);
    }
    
    if(error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Profile.Alert.FormError.Title", nil)
                                                                message:[NSString stringWithFormat:NSLocalizedString(@"Profile.Alert.FormError.Message", nil), error]
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Profile.Alert.FormError.Action.OK", nil)
                                                      otherButtonTitles:nil];
        
        alertView.tag = ALERT_FORM;
        [alertView show];
        return;
    }
    
    // Create change-set
    if(email && ![m_details.email isEqualToString:email]) {
        details.email = email;
    }
    
    if(phone && ![m_details.phone isEqualToString:phone]) {
        details.phone = phone;
    }
    
    if(firstName && ![m_details.firstName isEqualToString:firstName]) {
        details.firstName = firstName;
    }
    
    if(lastName && ![m_details.lastName isEqualToString:lastName]) {
        details.lastName = lastName;
    }
    
    if(countryId && ![m_details.countryId isEqualToString:countryId]) {
        details.countryId = countryId;
    }
    
    if(city && ![m_details.city isEqualToString:city]) {
        details.city = city;
    }
    
    if(address && ![m_details.address isEqualToString:address]) {
        details.address = address;
    }
    
    if(zipcode && ![m_details.zipcode isEqualToString:zipcode]) {
        details.zipcode = zipcode;
    }
    
    // Do nothing if there are no changes
    if(details.empty) {
        [self dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    
    // Post changes
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    if(!m_hud) {
        m_hud = [[MBProgressHUD alloc] initWithView:self.view];
        m_hud.labelText = NSLocalizedString(@"Profile.Label.Saving", nil);
        m_hud.labelFont = [UIFont themeBoldFontOfSize:16.0F];
        m_hud.detailsLabelFont = [UIFont themeBoldFontOfSize:12.0F];
        [self.view addSubview:m_hud];
        [m_hud show:YES];
    }
    
    [self saveData:details];
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

- (id)pickerField:(MFFormPickerField *)pickerField dataForRow:(NSInteger)row
{
    return [m_countries objectAtIndex:row];
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

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch(alertView.tag) {
        case ALERT_LOAD:
            if(alertView.cancelButtonIndex != buttonIndex) {
                [self loadData];
            } else {
                [self cancel:nil];
            }
            break;
        case ALERT_SAVE:
            if(alertView.cancelButtonIndex != buttonIndex) {
                [self done:nil];
            }
            break;
        case ALERT_FORM:
            break;
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return ([textField isKindOfClass:[MFFormTextField class]]) ? [(MFFormTextField *)textField shouldChangeCharactersInRange:range replacementString:string] : YES;
}

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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return ([textView isKindOfClass:[MFFormTextView class]]) ? [(MFFormTextView *)textView shouldChangeCharactersInRange:range replacementString:text] : YES;
}

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
    textField.maxTextLength = 256;
    textField.tag = TAG_FIELD_FULLNAME;
    [form addSubview:textField];
    [fields addObject:textField];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.AddressLine", nil);
    [form addSubview:label];
    
    textView = [[MFFormTextView alloc] initWithFrame:CGRectMake(10.0F, 220.0F, 300.0F, 2.0F * [MFFormLabel preferredHeight])];
    textView.delegate = self;
    textView.placeholder = NSLocalizedString(@"Profile.Hint.AddressLine", nil);
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.tag = TAG_FIELD_ADDRESS;
    textView.maxTextLength = 128;
    [form addSubview:textView];
    [fields addObject:textView];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.Country", nil);
    [form addSubview:label];
    
    pickerField = [[MFFormPickerField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormPickerField preferredHeight])];
    pickerField.dataSource = self;
    pickerField.delegate = self;
    pickerField.placeholder = NSLocalizedString(@"Profile.Hint.Country", nil);
    pickerField.tag = TAG_FIELD_COUNTRY;
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
    textField.tag = TAG_FIELD_CITY;
    textField.maxTextLength = 64;
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
    textField.tag = TAG_FIELD_ZIPCODE;
    textField.maxTextLength = 16;
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
    textField.maxTextLength = 128;
    textField.tag = TAG_FIELD_PHONE;
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
    textField.tag = TAG_FIELD_EMAIL;
    textField.maxTextLength = 128;
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
    [self invalidate];
    
    if(!m_details) {
        [self loadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[MFWebService sharedService] cancelRequestsForTarget:self];
    
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
