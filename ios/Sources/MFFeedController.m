/* Copyright (c) 2013 Meep Factory OU */

#import "MFFeedController.h"
#import "MFPostController.h"
#import "MFSideMenuContainerViewController.h"
#import "UIViewController+MFSideMenuAdditions.h"

@implementation MFFeedController

- (IBAction)filter:(id)sender
{
    MFPostController *controller = [[MFPostController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)menu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

#pragma mark UIView

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
    tableView.backgroundColor = [UIColor blueColor];
    
    self.view = tableView;
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Feed.Action.Home", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"x" style:UIBarButtonItemStyleBordered target:self action:@selector(filter:)];
        
    }
    
    return self;
}

@end
