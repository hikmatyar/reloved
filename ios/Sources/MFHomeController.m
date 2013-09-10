/* Copyright (c) 2013 Meep Factory OU */

#import "MFHomeController.h"
#import "MFSideMenuContainerViewController.h"
#import "UIViewController+MFSideMenuAdditions.h"
#import "MFWebController.h"

@implementation MFHomeController

- (IBAction)menu:(id)sender
{
    //[self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Contact-Us"] animated:YES];
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
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
    }
    
    return self;
}

@end
