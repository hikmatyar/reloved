/* Copyright (c) 2013 Meep Factory OU */

#import "MFCheckoutController+Cart.h"
#import "MFCheckoutPageView.h"

@interface MFCheckoutController_Cart : MFCheckoutPageView

@end

@implementation MFCheckoutController_Cart

#pragma mark MFNewPostPageView

- (id)initWithFrame:(CGRect)frame controller:(MFCheckoutController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
        
    }
    
    return self;
}

@end

#pragma mark -

@implementation MFCheckoutController(Cart)

- (MFCheckoutPageView *)createCartPageView
{
    return [[MFCheckoutController_Cart alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
