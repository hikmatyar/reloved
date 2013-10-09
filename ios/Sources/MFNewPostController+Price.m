/* Copyright (c) 2013 Meep Factory OU */

#import "MFForm.h"
#import "MFFormAccessory.h"
#import "MFFormFooter.h"
#import "MFFormLabel.h"
#import "MFFormTextField.h"
#import "MFNewPostController+Price.h"
#import "MFNewPostPageView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@interface MFNewPostController_Price : MFNewPostPageView <UITextFieldDelegate>
{
    @private
    MFFormAccessory *m_accessory;
    BOOL m_canContinue;
    MFFormTextField *m_priceTextField;
    MFFormTextField *m_priceOriginalTextField;
    MFForm *m_form;
}

@end

@implementation MFNewPostController_Price

#pragma mark MFNewPostPageView

- (id)initWithFrame:(CGRect)frame controller:(MFNewPostController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
        MFFormFooter *footer;
        MFFormLabel *label;
        
        m_form = [[MFForm alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        m_form.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:m_form];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"NewPost.Label.Price", nil);
        [m_form addSubview:label];
        
        m_priceTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_priceTextField.delegate = self;
        m_priceTextField.returnKeyType = UIReturnKeyNext;
        m_priceTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        m_priceTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        m_priceTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        m_priceTextField.placeholder = NSLocalizedString(@"NewPost.Hint.PriceNew", nil);
        m_priceTextField.leftText = NSLocalizedString(@"NewPost.Hint.GBP", nil);
        [m_form addSubview:m_priceTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"NewPost.Label.OriginalPrice", nil);
        [m_form addSubview:label];
        
        m_priceOriginalTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_priceOriginalTextField.delegate = self;
        m_priceOriginalTextField.returnKeyType = UIReturnKeyNext;
        m_priceOriginalTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        m_priceOriginalTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        m_priceOriginalTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        m_priceOriginalTextField.placeholder = NSLocalizedString(@"NewPost.Hint.PriceOriginal", nil);
        m_priceOriginalTextField.leftText = NSLocalizedString(@"NewPost.Hint.GBP", nil);
        [m_form addSubview:m_priceOriginalTextField];
        
        footer = [[MFFormFooter alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        footer.text = NSLocalizedString(@"NewPost.Hint.Price", nil);
        [m_form addSubview:footer];
        
        m_accessory = [[MFFormAccessory alloc] initWithContext:m_form];
    }
    
    return self;
}

- (BOOL)canContinue
{
    if(!m_canContinue) {
        m_canContinue = (m_priceTextField.text.length > 0 && m_priceOriginalTextField.text.length > 0) ? YES : NO;
    }
    
    return m_canContinue;
}

#pragma mark MFPageView

- (void)pageWillAppear
{
    [m_accessory activate];
}

- (void)pageWillDisappear
{
    MFFormTextField *priceOriginalTextField = m_priceOriginalTextField;
    
    m_priceOriginalTextField = nil;
    [m_priceTextField resignFirstResponder];
    [priceOriginalTextField resignFirstResponder];
    m_priceOriginalTextField = priceOriginalTextField;
    //[m_accessory deactivate];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == m_priceTextField) {
        [m_priceOriginalTextField becomeFirstResponder];
    } else if(textField == m_priceOriginalTextField) {
        [m_controller next:nil];
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [m_form scrollToView:textField animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [m_controller invalidateNavigation];
}

@end

#pragma mark -

@implementation MFNewPostController(Price)

- (MFNewPostPageView *)createPricePageView
{
    return [[MFNewPostController_Price alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end