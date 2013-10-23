/* Copyright (c) 2013 Meep Factory OU */

#import "MFCheckoutController+Payment.h"
#import "MFCheckoutPageView.h"
#import "MFForm.h"
#import "MFFormAccessory.h"
#import "MFFormFooter.h"
#import "MFFormLabel.h"
#import "MFFormTextField.h"
#import "STPView.h"

@interface MFCheckoutController_Payment : MFCheckoutPageView <UITextFieldDelegate>
{
    @private
    MFFormAccessory *m_accessory;
    MFFormTextField *m_cardHolderTextField;
    MFFormTextField *m_cardNumberTextField;
    MFFormTextField *m_cardExpiryTextField;
    MFFormTextField *m_cardCVCTextField;
    BOOL m_canContinue;
    MFForm *m_form;
    STPView *m_stripeView;
}

@end

@implementation MFCheckoutController_Payment

#pragma mark MFCheckoutPageView

- (id)initWithFrame:(CGRect)frame controller:(MFCheckoutController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
        NSMutableArray *fields = [NSMutableArray array];
        MFFormFooter *footer;
        MFFormLabel *label;
        
        m_form = [[MFForm alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"Checkout.Label.CardHolder", nil);
        [m_form addSubview:label];
        
        m_cardHolderTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_cardHolderTextField.delegate = self;
        m_cardHolderTextField.returnKeyType = UIReturnKeyNext;
        m_cardHolderTextField.placeholder = NSLocalizedString(@"Checkout.Hint.CardHolder", nil);
        m_cardHolderTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        m_cardHolderTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        m_cardHolderTextField.maxTextLength = 256;
        [m_form addSubview:m_cardHolderTextField];
        [fields addObject:m_cardHolderTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"Checkout.Hint.CardNumber", nil);
        [m_form addSubview:label];
        
        m_cardNumberTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_cardNumberTextField.delegate = self;
        m_cardNumberTextField.returnKeyType = UIReturnKeyNext;
        m_cardNumberTextField.placeholder = NSLocalizedString(@"Checkout.Hint.CardNumber", nil);
        m_cardNumberTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        m_cardNumberTextField.maxTextLength = 64;
        [m_form addSubview:m_cardNumberTextField];
        [fields addObject:m_cardNumberTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"Checkout.Label.CardExpiry", nil);
        [m_form addSubview:label];
        
        m_cardExpiryTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_cardExpiryTextField.delegate = self;
        m_cardExpiryTextField.returnKeyType = UIReturnKeyNext;
        m_cardExpiryTextField.placeholder = NSLocalizedString(@"Checkout.Hint.CardExpiry", nil);
        m_cardExpiryTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        m_cardExpiryTextField.maxTextLength = 16;
        [m_form addSubview:m_cardExpiryTextField];
        [fields addObject:m_cardExpiryTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        [label setText:NSLocalizedString(@"Checkout.Hint.CardCVC", nil) hint:NSLocalizedString(@"Checkout.Hint.CardCVC.Extra", nil)];
        [m_form addSubview:label];
        
        m_cardCVCTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_cardCVCTextField.delegate = self;
        m_cardCVCTextField.returnKeyType = UIReturnKeyNext;
        m_cardCVCTextField.placeholder = NSLocalizedString(@"Checkout.Hint.CardCVC", nil);
        m_cardCVCTextField.keyboardType = UIKeyboardTypePhonePad;
        m_cardCVCTextField.maxTextLength = 128;
        [m_form addSubview:m_cardCVCTextField];
        [fields addObject:m_cardCVCTextField];
        
        footer = [[MFFormFooter alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormFooter preferredHeight])];
        footer.lineBreakMode = NSLineBreakByWordWrapping;
        footer.text = NSLocalizedString(@"Checkout.Hint.Card", nil);
        [footer sizeToFit];
        [m_form addSubview:footer];
        
        m_form.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:m_form];
        
        m_accessory = [[MFFormAccessory alloc] initWithContext:m_form];
        m_accessory.fields = fields;
    }
    
    return self;
}

#pragma mark MFPageView

- (void)pageWillAppear
{
    [super pageWillAppear];
    [m_accessory activate];
}

- (void)pageWillDisappear
{
    [super pageWillDisappear];
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

@end

#pragma mark -

@implementation MFCheckoutController(Payment)

- (MFCheckoutPageView *)createPaymentPageView
{
    return [[MFCheckoutController_Payment alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
