/* Copyright (c) 2013 Meep Factory OU */

#import "MFCartController.h"
#import "MFFeedController.h"
#import "MFHomeController.h"
#import "MFMenuController.h"
#import "MFSearchController.h"

@implementation MFMenuController

#pragma mark UIView

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
    tableView.backgroundColor = [UIColor redColor];
    
    self.view = tableView;
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
    }
    
    return self;
}

@end
