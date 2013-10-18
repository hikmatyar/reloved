/* Copyright (c) 2013 Meep Factory OU */

#import "MFProgressViewDelegate.h"

@class MBProgressHUD;

@interface MFCheckoutController : UIViewController <MFProgressViewDelegate>
{
    @private
    MBProgressHUD *m_hud;
    NSArray *m_steps;
    NSInteger m_stepIndex;
}

- (IBAction)menu:(id)sender;
- (IBAction)next:(id)sender;

- (void)invalidateNavigation;

@end
