/* Copyright (c) 2013 Meep Factory OU */

#import "MFFeedController.h"
#import "MFPostController.h"
#import "MFTableView.h"
#import "MFWebFeed.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFFeedController

@dynamic tableView;

- (UITableView *)tableView
{
    return (UITableView *)self.view;
}

@dynamic feed;

- (MFWebFeed *)feed
{
    return m_feed;
}

- (void)setFeed:(MFWebFeed *)feed
{
    if(m_feed != feed) {
        m_feed = feed;
        [self.tableView reloadData];
    }
}

- (IBAction)filter:(id)sender
{
    MFPostController *controller = [[MFPostController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark UITableViewDelegate

#pragma mark UIView

- (void)loadView
{
    MFTableView *tableView = [[MFTableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
    tableView.backgroundColor = [UIColor themeBackgroundColor];
    
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
