/* Copyright (c) 2013 Meep Factory OU */

#import "MFCheckoutController+Receipt.h"
#import "MFCheckoutPageView.h"

@interface MFCheckoutController_Receipt : MFCheckoutPageView

@end

@implementation MFCheckoutController_Receipt

@end

#pragma mark -

@implementation MFCheckoutController(Receipt)

- (MFCheckoutPageView *)createReceiptPageView
{
    return [[MFCheckoutController_Receipt alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
