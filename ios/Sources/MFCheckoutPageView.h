/* Copyright (c) 2013 Meep Factory OU */

#import "MFPageView.h"

@class MFCheckoutController;

@interface MFCheckoutPageView : MFPageView
{
    @protected
    __unsafe_unretained MFCheckoutController *m_controller;
}

- (id)initWithFrame:(CGRect)frame controller:(MFCheckoutController *)controller;

- (BOOL)canContinue;

@end
