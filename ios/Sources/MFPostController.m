/* Copyright (c) 2013 Meep Factory OU */

#import "MFPost.h"
#import "MFPostController.h"
#import "MFWebPost.h"

@implementation MFPostController

- (id)initWithPost:(MFWebPost *)post
{
    self = [super init];
    
    if(self) {
        m_post = post;
    }
    
    return self;
}

#pragma mark UIView

- (void)loadView
{
    UIView *view = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
    view.backgroundColor = [UIColor blueColor];
    
    self.view = view;
}

@end
