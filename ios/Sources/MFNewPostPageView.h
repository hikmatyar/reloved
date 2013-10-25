/* Copyright (c) 2013 Meep Factory OU */

#import "MFPageView.h"

@class MFNewPostController;

@interface MFNewPostPageView : MFPageView
{
    @protected
    __unsafe_unretained MFNewPostController *m_controller;
}

- (id)initWithFrame:(CGRect)frame controller:(MFNewPostController *)controller;

- (MFNewPostPageView *)createFreshView;
- (BOOL)canContinue;
- (void)saveState;
- (void)submitting;

@end
