/* Copyright (c) 2013 Meep Factory OU */

#import "MFCart.h"
#import "MFCheckoutController+Address.h"
#import "MFCheckoutPageView.h"
#import "MFCountry.h"
#import "MFDatabase+Country.h"
#import "MFForm.h"
#import "MFFormAccessory.h"
#import "MFFormFooter.h"
#import "MFFormLabel.h"
#import "MFFormPickerField.h"
#import "MFFormPickerFieldDataSource.h"
#import "MFFormPickerFieldDelegate.h"
#import "MFFormTextField.h"
#import "MFFormTextView.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@interface MFCheckoutController_Address : MFCheckoutPageView <MFFormPickerFieldDataSource, MFFormPickerFieldDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    @private
    MFFormAccessory *m_accessory;
    MFFormTextField *m_fullNameTextField;
    MFFormTextView *m_addressTextView;
    MFFormTextField *m_cityTextField;
    MFFormTextField *m_zipCodeTextField;
    MFFormTextField *m_phoneTextField;
    MFFormTextField *m_emailTextField;
    MFFormPickerField *m_countryPickerField;
    BOOL m_canContinue;
    NSArray *m_countries;
    MFForm *m_form;
}

@end

@implementation MFCheckoutController_Address

- (void)invalidateCountries
{
    NSArray *dbCountries = [[MFDatabase sharedDatabase].countries sortedArrayUsingSelector:@selector(compare:)];
    MFCountry *selection = m_countryPickerField.selectedData;
    NSMutableArray *countries = [[NSMutableArray alloc] init];
    
    if(dbCountries) {
        [(NSMutableArray *)countries addObjectsFromArray:dbCountries];
    }
    
    [(NSMutableArray *)countries insertObject:[[MFCountry alloc] initWithName:NSLocalizedString(@"Checkout.Hint.Country", nil)] atIndex:0];
    
    if(!MFEqual(m_countries, countries)) {
        NSInteger index = (selection) ? [countries indexOfObject:selection] : NSNotFound;
        
        m_countries = countries;
        [m_countryPickerField reloadData];
        m_countryPickerField.selectedRow = (index != NSNotFound) ? index : 0;
    }
}

- (void)loadState
{
    MFMutableCart *cart = m_controller.cart;
    NSString *countryId = cart.countryId;
    
    m_emailTextField.text = cart.email;
    m_phoneTextField.text = cart.phone;
    m_fullNameTextField.text = cart.fullName;
    m_cityTextField.text = cart.city;
    m_addressTextView.text = cart.address;
    m_zipCodeTextField.text = cart.zipcode;
    
    if(countryId) {
        for(NSInteger i = 0, c = m_countries.count; i < c; i++) {
            MFCountry *country = [m_countries objectAtIndex:i];
            
            if([country.identifier isEqualToString:countryId]) {
                m_countryPickerField.selectedRow = i;
                break;
            }
        }
    } else {
        m_countryPickerField.selectedRow = 0;
    }
}

- (void)saveState
{
    NSArray *fullName = [m_fullNameTextField.text.stringByTrimmingWhitespace componentsSeparatedByString:@" "];
    NSString *firstName = fullName.firstObject;
    NSString *lastName = (fullName.count > 1) ? [[fullName subarrayWithRange:NSMakeRange(1, fullName.count - 1)] componentsJoinedByString:@" "] : @"";
    MFMutableCart *cart = m_controller.cart;
    
    cart.firstName = firstName;
    cart.lastName = lastName;
    cart.address = m_addressTextView.text.stringByTrimmingWhitespace;
    cart.city = m_cityTextField.text.stringByTrimmingWhitespace;
    cart.zipcode = m_zipCodeTextField.text.stringByTrimmingWhitespace;
    cart.phone = m_phoneTextField.text.stringByTrimmingWhitespace;
    cart.email = m_emailTextField.text.stringByTrimmingWhitespace;
    cart.countryId = ((MFCountry *)m_countryPickerField.selectedData).identifier;
}

#pragma mark MFCheckoutPageView

- (id)initWithFrame:(CGRect)frame controller:(MFCheckoutController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
        NSMutableArray *fields = [NSMutableArray array];
        MFFormFooter *footer;
        MFFormLabel *label;
        
        m_form = [[MFForm alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        
        [self invalidateCountries];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"Checkout.Label.FullName", nil);
        [m_form addSubview:label];
        
        m_fullNameTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_fullNameTextField.delegate = self;
        m_fullNameTextField.returnKeyType = UIReturnKeyNext;
        m_fullNameTextField.placeholder = NSLocalizedString(@"Checkout.Hint.FullName", nil);
        m_fullNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        m_fullNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        m_fullNameTextField.maxTextLength = 256;
        [m_form addSubview:m_fullNameTextField];
        [fields addObject:m_fullNameTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"Checkout.Label.AddressLine", nil);
        [m_form addSubview:label];
        
        m_addressTextView = [[MFFormTextView alloc] initWithFrame:CGRectMake(10.0F, 220.0F, 300.0F, 2.0F * [MFFormLabel preferredHeight])];
        m_addressTextView.delegate = self;
        m_addressTextView.placeholder = NSLocalizedString(@"Checkout.Hint.AddressLine", nil);
        m_addressTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        m_addressTextView.maxTextLength = 128;
        [m_form addSubview:m_addressTextView];
        [fields addObject:m_addressTextView];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"Checkout.Label.Country", nil);
        [m_form addSubview:label];
        
        m_countryPickerField = [[MFFormPickerField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormPickerField preferredHeight])];
        m_countryPickerField.dataSource = self;
        m_countryPickerField.delegate = self;
        m_countryPickerField.placeholder = NSLocalizedString(@"Checkout.Hint.Country", nil);
        [m_form addSubview:m_countryPickerField];
        [fields addObject:m_countryPickerField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"Checkout.Label.City", nil);
        [m_form addSubview:label];
        
        m_cityTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_cityTextField.delegate = self;
        m_cityTextField.returnKeyType = UIReturnKeyNext;
        m_cityTextField.placeholder = NSLocalizedString(@"Checkout.Hint.City", nil);
        m_cityTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        m_cityTextField.maxTextLength = 64;
        [m_form addSubview:m_cityTextField];
        [fields addObject:m_cityTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"Checkout.Label.Postcode", nil);
        [m_form addSubview:label];
        
        m_zipCodeTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_zipCodeTextField.delegate = self;
        m_zipCodeTextField.returnKeyType = UIReturnKeyNext;
        m_zipCodeTextField.placeholder = NSLocalizedString(@"Checkout.Hint.Postcode", nil);
        m_zipCodeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        m_zipCodeTextField.maxTextLength = 16;
        [m_form addSubview:m_zipCodeTextField];
        [fields addObject:m_zipCodeTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"Checkout.Label.Phone", nil);
        [m_form addSubview:label];
        
        m_phoneTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_phoneTextField.delegate = self;
        m_phoneTextField.returnKeyType = UIReturnKeyNext;
        m_phoneTextField.placeholder = NSLocalizedString(@"Checkout.Hint.Phone", nil);
        m_phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        m_phoneTextField.maxTextLength = 128;
        [m_form addSubview:m_phoneTextField];
        [fields addObject:m_phoneTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"Checkout.Label.Email", nil);
        [m_form addSubview:label];
        
        m_emailTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_emailTextField.delegate = self;
        m_emailTextField.returnKeyType = UIReturnKeyDone;
        m_emailTextField.placeholder = NSLocalizedString(@"Checkout.Hint.Email", nil);
        m_emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        m_emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        m_emailTextField.maxTextLength = 128;
        [m_form addSubview:m_emailTextField];
        [fields addObject:m_emailTextField];
        
        footer = [[MFFormFooter alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormFooter preferredHeight])];
        footer.lineBreakMode = NSLineBreakByWordWrapping;
        footer.text = NSLocalizedString(@"Checkout.Hint.Shipping", nil);
        //[footer sizeToFit];
        [m_form addSubview:footer];
        
        m_form.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:m_form];
        
        m_accessory = [[MFFormAccessory alloc] initWithContext:m_form];
        m_accessory.fields = fields;
    }
    
    return self;
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
    [m_form scrollToView:pickerField animated:YES];
    [m_accessory invalidate];
}

- (void)pickerField:(MFFormPickerField *)pickerField didSelectRow:(NSInteger)row
{
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return ([textField isKindOfClass:[MFFormTextField class]]) ? [(MFFormTextField *)textField shouldChangeCharactersInRange:range replacementString:string] : YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [m_form scrollToView:textField animated:YES];
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
    [m_form scrollToView:textView animated:YES];
    [m_accessory invalidate];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
}

#pragma mark MFPageView

- (void)pageWillAppear
{
    [super pageWillAppear];
    [self invalidateCountries];
    [self loadState];
    [m_accessory activate];
}

- (void)pageWillDisappear
{
    [super pageWillDisappear];
    [self saveState];
    
    [m_fullNameTextField resignFirstResponder];
    [m_addressTextView resignFirstResponder];
    [m_cityTextField resignFirstResponder];
    [m_zipCodeTextField resignFirstResponder];
    [m_phoneTextField resignFirstResponder];
    [m_emailTextField resignFirstResponder];
    [m_countryPickerField resignFirstResponder];
}

@end

#pragma mark -

@implementation MFCheckoutController(Address)

- (MFCheckoutPageView *)createAddressPageView
{
    return [[MFCheckoutController_Address alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
