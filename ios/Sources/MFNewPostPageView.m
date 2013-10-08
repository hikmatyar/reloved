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

- (BOOL)canContinue
{
    return YES;
}

- (void)submitting
{
}

@end
