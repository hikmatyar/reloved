/* Copyright (c) 2013 Meep Factory OU */

#import "MFCheckoutController+Payment.h"
#import "MFCheckoutPageView.h"

@interface MFCheckoutController_Payment : MFCheckoutPageView

@end

@implementation MFCheckoutController_Payment

@end

#pragma mark -

@implementation MFCheckoutController(Payment)

- (MFCheckoutPageView *)createPaymentPageView
{
    return [[MFCheckoutController_Payment alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
