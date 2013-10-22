/* Copyright (c) 2013 Meep Factory OU */

#import "MFCheckoutController.h"
#import "MFCheckoutPageView.h"

@implementation MFCheckoutPageView

- (id)initWithFrame:(CGRect)frame controller:(MFCheckoutController *)controller
{
    self = [super initWithFrame:frame];
    
    if(self) {
        m_controller = controller;
    }
    
    return self;
}

- (void)cartDidChange
{
}

- (BOOL)canContinue
{
    return YES;
}

@end
