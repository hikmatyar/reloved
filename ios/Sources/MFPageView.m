/* Copyright (c) 2013 Meep Factory OU */

#import "MFPageView.h"

@implementation MFPageView

- (void)pageWillAppear
{
}

- (void)pageDidAppear
{
}

- (void)pageWillDisappear
{
}

- (void)pageDidDisappear
{
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}

@end
