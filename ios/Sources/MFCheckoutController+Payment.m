/* Copyright (c) 2013 Meep Factory OU */

#import "MFCheckoutController+Payment.h"
#import "MFCheckoutPageView.h"
#import "MFForm.h"
#import "MFFormAccessory.h"
#import "MFFormContainer.h"
#import "MFFormFooter.h"
#import "MFFormLabel.h"
#import "STPView.h"

@interface MFCheckoutController_Payment : MFCheckoutPageView <STPViewDelegate>
{
    @private
    MFFormAccessory *m_accessory;
    MFFormContainer *m_container;
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
        MFFormFooter *footer;
        MFFormLabel *label;
        
        m_form = [[MFForm alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        [label setText:NSLocalizedString(@"Checkout.Label.Card", nil) hint:NSLocalizedString(@"Checkout.Label.Card.Extra", nil)];
        [m_form addSubview:label];
        
        m_container = [[MFFormContainer alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 62.0F)];
        
        m_stripeView = [[STPView alloc] initWithFrame:CGRectMake(15.0F, 7.0F, 290.0F, 55.0F) andKey:STRIPE_KEY];
        [m_form addSubview:m_container];
        
        footer = [[MFFormFooter alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormFooter preferredHeight])];
        footer.lineBreakMode = NSLineBreakByWordWrapping;
        footer.text = NSLocalizedString(@"Checkout.Hint.Card", nil);
        [footer sizeToFit];
        [m_form addSubview:footer];
        
        m_form.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:m_form];
        
        m_accessory = [[MFFormAccessory alloc] initWithContext:m_form];
    }
    
    return self;
}

#pragma mark MFPageView

- (void)pageWillAppear
{
    [super pageWillAppear];
    [m_accessory activate];
    [m_container addSubview:m_stripeView];
}

- (void)pageWillDisappear
{
    [super pageWillDisappear];
}

- (void)pageDidDisappear
{
    [m_stripeView removeFromSuperview];
    [super pageDidDisappear];
}

#pragma mark STPViewDelegate

- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    NSLog(@"123");
}

@end

#pragma mark -

@implementation MFCheckoutController(Payment)

- (MFCheckoutPageView *)createPaymentPageView
{
    return [[MFCheckoutController_Payment alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
