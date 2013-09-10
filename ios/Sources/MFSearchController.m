/* Copyright (c) 2013 Meep Factory OU */

#import "MFSearchController.h"
#import "MFSideMenuContainerViewController.h"
#import "UIViewController+MFSideMenuAdditions.h"

@implementation MFSearchController

- (IBAction)menu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
}

#pragma mark UIView

- (void)loadView
{
    UIView *view = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
    view.backgroundColor = [UIColor blueColor];
    
    self.view = view;
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
    }
    
    return self;
}

@end
