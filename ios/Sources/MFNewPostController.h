/* Copyright (c) 2013 Meep Factory OU */

#import "MFNewPostProgressViewDelegate.h"

@interface MFNewPostController : UIViewController <MFNewPostProgressViewDelegate>
{
    @private
    NSArray *m_steps;
}

- (IBAction)menu:(id)sender;

- (void)invalidateNavigation;

@end
