/* Copyright (c) 2013 Meep Factory OU */

#import "MFCheckoutController.h"

@class MFCheckoutPageView;

@interface MFCheckoutController(Payment)

- (MFCheckoutPageView *)createPaymentPageView;

@end
