/* Copyright (c) 2013 Meep Factory OU */

#import "MFProgressViewDelegate.h"

@class MBProgressHUD;
@class MFMutablePost;

@interface MFNewPostController : UIViewController <MFProgressViewDelegate>
{
    @private
    MBProgressHUD *m_hud;
    NSArray *m_steps;
    NSInteger m_stepIndex;
    MFMutablePost *m_post;
}

@property (nonatomic, retain, readonly) MFMutablePost *post;

- (IBAction)menu:(id)sender;
- (IBAction)next:(id)sender;

- (void)invalidateNavigation;

@end
