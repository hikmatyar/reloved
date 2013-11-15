/* Copyright (c) 2013 Meep Factory OU */

#import "MFForm.h"
#import "MFFormAccessory.h"
#import "MFFormFooter.h"
#import "MFFormLabel.h"
#import "MFFormTextField.h"
#import "MFNewPostController+Contacts.h"
#import "MFNewPostPageView.h"
#import "MFPost.h"
#import "NSString+Additions.h"

@interface MFNewPostController_Contacts : MFNewPostPageView <UITextFieldDelegate>
{
    @private
    MFFormAccessory *m_accessory;
    MFFormTextField *m_fullNameTextField;
    MFFormTextField *m_phoneTextField;
    MFFormTextField *m_emailTextField;
    BOOL m_canContinue;
    MFForm *m_form;
}

@end

@implementation MFNewPostController_Contacts

#pragma mark MFNewPostPageView

- (id)initWithFrame:(CGRect)frame controller:(MFNewPostController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
        NSMutableArray *fields = [NSMutableArray array];
        MFFormFooter *footer;
        MFFormLabel *label;
        
        m_form = [[MFForm alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"NewPost.Label.FullName", nil);
        [m_form addSubview:label];
        
        m_fullNameTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_fullNameTextField.delegate = self;
        m_fullNameTextField.returnKeyType = UIReturnKeyNext;
        m_fullNameTextField.placeholder = NSLocalizedString(@"NewPost.Hint.FullName", nil);
        m_fullNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        m_fullNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        m_fullNameTextField.maxTextLength = 256;
        [m_form addSubview:m_fullNameTextField];
        [fields addObject:m_fullNameTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"NewPost.Label.Email", nil);
        [m_form addSubview:label];
        
        m_emailTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_emailTextField.delegate = self;
        m_emailTextField.returnKeyType = UIReturnKeyDone;
        m_emailTextField.placeholder = NSLocalizedString(@"NewPost.Hint.Email", nil);
        m_emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        m_emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        m_emailTextField.maxTextLength = 128;
        [m_form addSubview:m_emailTextField];
        [fields addObject:m_emailTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"NewPost.Label.Phone", nil);
        [m_form addSubview:label];
        
        m_phoneTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_phoneTextField.delegate = self;
        m_phoneTextField.returnKeyType = UIReturnKeyNext;
        m_phoneTextField.placeholder = NSLocalizedString(@"NewPost.Hint.Phone", nil);
        m_phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        m_phoneTextField.maxTextLength = 128;
        [m_form addSubview:m_phoneTextField];
        [fields addObject:m_phoneTextField];
        
        footer = [[MFFormFooter alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormFooter preferredHeight])];
        footer.lineBreakMode = NSLineBreakByWordWrapping;
        footer.text = NSLocalizedString(@"NewPost.Hint.Contacts", nil);
        //[footer sizeToFit];
        [m_form addSubview:footer];
        
        m_form.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:m_form];
        
        m_accessory = [[MFFormAccessory alloc] initWithContext:m_form];
        m_accessory.fields = fields;
    }
    
    return self;
}

- (void)loadState
{
    MFMutablePost *post = m_controller.post;
    
    m_emailTextField.text = post.email;
    m_phoneTextField.text = post.phone;
    m_fullNameTextField.text = post.fullName;
}

- (void)saveState
{
    NSArray *fullName = [m_fullNameTextField.text.stringByTrimmingWhitespace componentsSeparatedByString:@" "];
    NSString *firstName = fullName.firstObject;
    NSString *lastName = (fullName.count > 1) ? [[fullName subarrayWithRange:NSMakeRange(1, fullName.count - 1)] componentsJoinedByString:@" "] : @"";
    MFMutablePost *post = m_controller.post;
    
    post.firstName = firstName;
    post.lastName = lastName;
    post.phone = m_phoneTextField.text.stringByTrimmingWhitespace;
    post.email = m_emailTextField.text.stringByTrimmingWhitespace;
}

- (BOOL)canContinue
{
    if(!m_canContinue) {
        m_canContinue = (
            m_emailTextField.text.stringByTrimmingWhitespace.length > 0 &&
            m_fullNameTextField.text.stringByTrimmingWhitespace.length > 0) ? YES : NO;
    }
    
    return m_canContinue;
}

#pragma mark MFPageView

- (void)pageWillAppear
{
    [super pageWillAppear];
    [self loadState];
    [m_accessory activate];
}

- (void)pageWillDisappear
{
    [super pageWillDisappear];
    [self saveState];
    
    [m_fullNameTextField resignFirstResponder];
    [m_phoneTextField resignFirstResponder];
    [m_emailTextField resignFirstResponder];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [m_controller invalidateNavigation];
    
    return ([textField isKindOfClass:[MFFormTextField class]]) ? [(MFFormTextField *)textField shouldChangeCharactersInRange:range replacementString:string] : YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [m_form scrollToView:textField animated:YES];
    [m_accessory invalidate];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [m_controller invalidateNavigation];
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

@end

#pragma mark -

@implementation MFNewPostController(Contacts)

- (MFNewPostPageView *)createContactsPageView
{
    return [[MFNewPostController_Contacts alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
