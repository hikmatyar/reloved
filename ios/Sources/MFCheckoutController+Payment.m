/* Copyright (c) 2013 Meep Factory OU */

#import "MFCart.h"
#import "MFCheckoutController+Payment.h"
#import "MFCheckoutPageView.h"
#import "MFForm.h"
#import "MFFormAccessory.h"
#import "MFFormContainer.h"
#import "MFFormFooter.h"
#import "MFFormLabel.h"
#import "MFFormTextField.h"
#import "MFFormPKTextField.h"
#import "PKCard.h"
#import "PKCardExpiry.h"
#import "PKCardNumber.h"
#import "PKCardType.h"
#import "STPView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@interface MFCheckoutController_Payment : MFCheckoutPageView <PKViewDelegate, STPViewDelegate, UITextFieldDelegate>
{
    @private
    __unsafe_unretained id <PKViewDelegate> m_delegate;
    MFFormAccessory *m_accessory;
    MFFormTextField *m_cardHolderTextField;
    MFFormPKTextField *m_cardNumberTextField;
    MFFormPKTextField *m_cardExpiryTextField;
    MFFormPKTextField *m_cardCVCTextField;
    MFFormContainer *m_container;
    BOOL m_canContinue;
    MFForm *m_form;
    //STPView *m_stripeView;
    BOOL m_isInitialState;
    BOOL m_isValidState;
}

@property (nonatomic, assign) id <PKViewDelegate> delegate;

@end

@implementation MFCheckoutController_Payment

@synthesize delegate = m_delegate;

- (void)saveState
{
    
}

- (PKCardNumber*)cardNumber
{
    return [PKCardNumber cardNumberWithString:m_cardNumberTextField.text];
}

- (PKCardExpiry*)cardExpiry
{
    return [PKCardExpiry cardExpiryWithString:m_cardExpiryTextField.text];
}

- (PKCardCVC*)cardCVC
{
    return [PKCardCVC cardCVCWithString:m_cardCVCTextField.text];
}

- (PKCard*)card
{
    PKCard* card    = [[PKCard alloc] init];
    card.number     = [self.cardNumber string];
    card.cvc        = [self.cardCVC string];
    card.expMonth   = [self.cardExpiry month];
    card.expYear    = [self.cardExpiry year];
    
    return card;
}

- (BOOL)isValid
{    
    return [self.cardNumber isValid] && [self.cardExpiry isValid] &&
           [self.cardCVC isValid];
}

- (void)stateCardNumber
{
    if (!m_isInitialState) {
        // Animate left
        m_isInitialState = YES;
    }
    
    [m_cardNumberTextField becomeFirstResponder];
}

- (void)stateCardCVC
{
    [m_cardCVCTextField becomeFirstResponder];
}

- (void)stateMeta
{
    m_isInitialState = NO;
    [m_cardExpiryTextField becomeFirstResponder];
}

- (void)checkValid
{
    if ([self isValid]) {
        m_isValidState = YES;

        if ([self.delegate respondsToSelector:@selector(paymentView:withCard:isValid:)]) {
            [self.delegate paymentView:nil withCard:self.card isValid:YES];
        }
        
    } else if (![self isValid] && m_isValidState) {
        m_isValidState = NO;
        
        if ([self.delegate respondsToSelector:@selector(paymentView:withCard:isValid:)]) {
            [self.delegate paymentView:nil withCard:self.card isValid:NO];
        }
    }
}

- (void)textFieldIsValid:(UITextField *)textField {
    textField.textColor = [UIColor themeTextColor];
    [self checkValid];
}

- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors {
    if (errors) {
        textField.textColor = [UIColor themeTextErrorColor];
    } else {
        textField.textColor = [UIColor themeTextColor];
    }

    [self checkValid];
}

- (BOOL)cardNumberFieldShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [m_cardNumberTextField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:resultString];
    
    if ( ![cardNumber isPartiallyValid] )
        return NO;
    
    if (replacementString.length > 0) {
        m_cardNumberTextField.text = [cardNumber formattedStringWithTrail];
    } else {
        m_cardNumberTextField.text = [cardNumber formattedString];
    }
    
    //[self setPlaceholderToCardType];
    
    if ([cardNumber isValid]) {
        [self textFieldIsValid:m_cardNumberTextField];
        [self stateMeta];
        
    } else if ([cardNumber isValidLength] && ![cardNumber isValidLuhn]) {
        [self textFieldIsInvalid:m_cardNumberTextField withErrors:YES];
        
    } else if (![cardNumber isValidLength]) {
        [self textFieldIsInvalid:m_cardNumberTextField withErrors:NO];
    }
    
    return NO;
}

- (BOOL)cardExpiryShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [m_cardExpiryTextField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardExpiry *cardExpiry = [PKCardExpiry cardExpiryWithString:resultString];
    
    if (![cardExpiry isPartiallyValid]) return NO;
    
    // Only support shorthand year
    if ([cardExpiry formattedString].length > 5) return NO;
    
    if (replacementString.length > 0) {
        m_cardExpiryTextField.text = [cardExpiry formattedStringWithTrail];
    } else {
        m_cardExpiryTextField.text = [cardExpiry formattedString];
    }
    
    if ([cardExpiry isValid]) {
        [self textFieldIsValid:m_cardExpiryTextField];
        [self stateCardCVC];
        
    } else if ([cardExpiry isValidLength] && ![cardExpiry isValidDate]) {
        [self textFieldIsInvalid:m_cardExpiryTextField withErrors:YES];
    } else if (![cardExpiry isValidLength]) {
        [self textFieldIsInvalid:m_cardExpiryTextField withErrors:NO];
    }
    
    return NO;
}

- (BOOL)cardCVCShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [m_cardCVCTextField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardCVC *cardCVC = [PKCardCVC cardCVCWithString:resultString];
    PKCardType cardType = [[PKCardNumber cardNumberWithString:m_cardNumberTextField.text] cardType];
    
    // Restrict length
    if ( ![cardCVC isPartiallyValidWithType:cardType] ) return NO;
    
    // Strip non-digits
    m_cardCVCTextField.text = [cardCVC string];
    
    if ([cardCVC isValidWithType:cardType]) {
        [self textFieldIsValid:m_cardCVCTextField];
    } else {
        [self textFieldIsInvalid:m_cardCVCTextField withErrors:NO];
    }
    
    return NO;
}

#pragma mark MFCheckoutPageView

- (id)initWithFrame:(CGRect)frame controller:(MFCheckoutController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
        NSMutableArray *fields = [NSMutableArray array];
        MFFormFooter *footer;
        MFFormLabel *label;
        
        m_isInitialState = YES;
        m_isValidState = NO;
        
        m_delegate = self;
        m_form = [[MFForm alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        
        /*label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
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
        [fields addObject:m_cardHolderTextField];*/
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"Checkout.Label.CardNumber", nil);
        [m_form addSubview:label];
        
        m_cardNumberTextField = [[MFFormPKTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_cardNumberTextField.delegate = self;
        m_cardNumberTextField.returnKeyType = UIReturnKeyNext;
        m_cardNumberTextField.placeholder = NSLocalizedString(@"Checkout.Hint.CardNumber", nil);
        m_cardNumberTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        m_cardNumberTextField.keyboardType = UIKeyboardTypePhonePad;
        [m_form addSubview:m_cardNumberTextField];
        [fields addObject:m_cardNumberTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"Checkout.Label.CardExpiry", nil);
        [m_form addSubview:label];
        
        m_cardExpiryTextField = [[MFFormPKTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_cardExpiryTextField.delegate = self;
        m_cardExpiryTextField.returnKeyType = UIReturnKeyNext;
        m_cardExpiryTextField.placeholder = NSLocalizedString(@"Checkout.Hint.CardExpiry", nil);
        m_cardExpiryTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        m_cardExpiryTextField.keyboardType = UIKeyboardTypePhonePad;
        [m_form addSubview:m_cardExpiryTextField];
        [fields addObject:m_cardExpiryTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        [label setText:NSLocalizedString(@"Checkout.Hint.CardCVC", nil) hint:NSLocalizedString(@"Checkout.Hint.CardCVC.Extra", nil)];
        [m_form addSubview:label];
        
        m_cardCVCTextField = [[MFFormPKTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_cardCVCTextField.delegate = self;
        m_cardCVCTextField.returnKeyType = UIReturnKeyNext;
        m_cardCVCTextField.placeholder = NSLocalizedString(@"Checkout.Hint.CardCVC", nil);
        m_cardCVCTextField.keyboardType = UIKeyboardTypePhonePad;
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

- (BOOL)canContinue
{
    return m_canContinue;
}

#pragma mark MFPageView

- (void)pageWillAppear
{
    [super pageWillAppear];
    [m_accessory activate];
    //[m_container addSubview:m_stripeView];
}

- (void)pageWillDisappear
{
    [super pageWillDisappear];
    [self saveState];
}

- (void)pageDidDisappear
{
    //[m_stripeView removeFromSuperview];
    [super pageDidDisappear];
}

#pragma mark UITextFieldDelegate

- (void)pkTextFieldDidBackSpaceWhileTextIsEmpty:(PKTextField *)textField
{
    if (textField == m_cardCVCTextField)
        [m_cardExpiryTextField becomeFirstResponder];
    else if (textField == m_cardExpiryTextField)
        [self stateCardNumber];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if ([textField isEqual:m_cardNumberTextField]) {
        return [self cardNumberFieldShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    if ([textField isEqual:m_cardExpiryTextField]) {
        return [self cardExpiryShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    if ([textField isEqual:m_cardCVCTextField]) {
        return [self cardCVCShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    return YES;
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

#define mark PKViewDelegate

- (void)paymentView:(PKView *)paymentView withCard:(PKCard *)card isValid:(BOOL)valid
{
    [self stripeView:nil withCard:card isValid:valid];
}

#pragma mark STPViewDelegate

- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    m_controller.cart.card = card;
    m_canContinue = valid;
    [m_controller invalidateNavigation];
}

@end

#pragma mark -

@implementation MFCheckoutController(Payment)

- (MFCheckoutPageView *)createPaymentPageView
{
    return [[MFCheckoutController_Payment alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
