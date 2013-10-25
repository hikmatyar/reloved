/* Copyright (c) 2013 Meep Factory OU */

#import "MFNewPostController.h"
#import "MFNewPostPageView.h"

@implementation MFNewPostPageView

- (id)initWithFrame:(CGRect)frame controller:(MFNewPostController *)controller
{
    self = [super initWithFrame:frame];
    
    if(self) {
        m_controller = controller;
    }
    
    return self;
}

- (MFNewPostPageView *)createFreshView
{
    MFNewPostPageView *view = [[self.class alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:m_controller];
    
    view.autoresizingMask = self.autoresizingMask;
    view.frame = self.frame;
    
    return view;
}

- (BOOL)canContinue
{
    return YES;
}

- (void)saveState
{
}

- (void)submitting
{
}

#pragma mark MFPageView

- (void)pageWillDisappear
{
    [self saveState];
}

@end
