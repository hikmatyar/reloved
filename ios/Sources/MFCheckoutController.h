/* Copyright (c) 2013 Meep Factory OU */

#import "MFProgressViewDelegate.h"

@class MBProgressHUD;
@class MFMutableCart;

@interface MFCheckoutController : UIViewController <UIAlertViewDelegate, MFProgressViewDelegate>
{
    @private
    MFMutableCart *m_cart;
    MBProgressHUD *m_hud;
    NSArray *m_steps;
    NSInteger m_stepIndex;
}

@property (nonatomic, retain, readonly) MFMutableCart *cart;

- (IBAction)menu:(id)sender;
- (IBAction)next:(id)sender;

- (void)invalidateNavigation;

@end
