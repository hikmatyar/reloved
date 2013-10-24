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

- (MFCheckoutPageView *)createFreshView
{
    MFCheckoutPageView *view = [[self.class alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:m_controller];
    
    view.autoresizingMask = self.autoresizingMask;
    view.frame = self.frame;
    
    return view;
}

- (void)cartDidChange
{
}

- (BOOL)canContinue
{
    return YES;
}

@end
