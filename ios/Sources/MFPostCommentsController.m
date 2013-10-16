/* Copyright (c) 2013 Meep Factory OU */

#import "MFPost.h"
#import "MFPostCommentsController.h"
#import "MFWebPost.h"

@implementation MFPostCommentsController

- (id)initWithPost:(MFWebPost *)post
{
    self = [super init];
    
    if(self) {
        m_post = post;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
        self.title = NSLocalizedString(@"PostComments.Title", nil);
    }
    
    return self;
}

@synthesize post = m_post;

- (IBAction)refresh:(id)sender
{
}

#pragma mark UIView

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

@end
