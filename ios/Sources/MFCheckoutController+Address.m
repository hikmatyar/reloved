/* Copyright (c) 2013 Meep Factory OU */

#import "MFCheckoutController+Address.h"
#import "MFCheckoutPageView.h"

@interface MFCheckoutController_Address : MFCheckoutPageView

@end

@implementation MFCheckoutController_Address

@end

#pragma mark -

@implementation MFCheckoutController(Address)

- (MFCheckoutPageView *)createAddressPageView
{
    return [[MFCheckoutController_Address alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
