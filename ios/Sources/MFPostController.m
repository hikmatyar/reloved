/* Copyright (c) 2013 Meep Factory OU */

#import "MFPostController.h"

@implementation MFPostController

#pragma mark UIView

- (void)loadView
{
    UIView *view = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
    view.backgroundColor = [UIColor blueColor];
    
    self.view = view;
}

@end
