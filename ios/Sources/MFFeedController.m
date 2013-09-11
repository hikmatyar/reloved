/* Copyright (c) 2013 Meep Factory OU */

#import "MFFeedController.h"
#import "MFPostController.h"

@implementation MFFeedController

- (IBAction)filter:(id)sender
{
    MFPostController *controller = [[MFPostController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
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
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Filter"] style:UIBarButtonItemStyleBordered target:self action:@selector(filter:)];
    }
    
    return self;
}

@end
