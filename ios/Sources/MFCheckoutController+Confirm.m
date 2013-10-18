/* Copyright (c) 2013 Meep Factory OU */

#import "MFCheckoutController+Confirm.h"
#import "MFCheckoutPageView.h"

@interface MFCheckoutController_Confirm : MFCheckoutPageView

@end

@implementation MFCheckoutController_Confirm

@end

#pragma mark -

@implementation MFCheckoutController(Confirm)

- (MFCheckoutPageView *)createConfirmPageView
{
    return [[MFCheckoutController_Confirm alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
