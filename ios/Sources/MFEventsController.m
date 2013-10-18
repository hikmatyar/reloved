/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase+Event.h"
#import "MFEvent.h"
#import "MFEventTableViewCell.h"
#import "MFEventsController.h"
#import "MFTableView.h"
#import "MFSideMenuContainerViewController.h"
#import "MFWebFeed.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+MFSideMenuAdditions.h"

#define CELL_IDENTIFIER @"cell"

#define TAG_TABLEVIEW 1000

@implementation MFEventsController

- (MFTableView *)tableView
{
    return (MFTableView *)[self.view viewWithTag:TAG_TABLEVIEW];
}

- (IBAction)menu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
}

- (IBAction)refresh:(id)sender
{
    [[MFWebFeed sharedFeed] loadForward];
}

- (void)databaseEventsDidChange:(NSNotification *)notification
{
    NSArray *events = [MFDatabase sharedDatabase].events;
    
    if(!MFEqual(m_events, events)) {
        m_events = events;
        [self.tableView reloadData];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFEventTableViewCell *cell = (MFEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    MFEvent *event = [m_events objectAtIndex:indexPath.row];
    
    if(!cell) {
        cell = [[MFEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.event = event;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFEvent *event = [m_events objectAtIndex:indexPath.row];
    NSString *link = event.link;
    
    if(link) {
        
    }
}

#pragma mark UIViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    MFTableView *tableView = [[MFTableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) style:UITableViewStylePlain];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 48.0F;
    tableView.backgroundColor = [UIColor themeBackgroundColor];
    tableView.separatorColor = [UIColor themeSeparatorColor];
    tableView.allowsMultipleSelection = NO;
    tableView.placeholder = NSLocalizedString(@"Events.Label.NoData", nil);
    tableView.tag = TAG_TABLEVIEW;
    
    view.backgroundColor = [UIColor themeBackgroundColor];
    [view addSubview:tableView];
    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(databaseEventsDidChange:) name:MFDatabaseDidChangeEventsNotification object:[MFDatabase sharedDatabase]];
    [self databaseEventsDidChange:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MFDatabaseDidChangeEventsNotification object:[MFDatabase sharedDatabase]];
    [super viewWillDisappear:animated];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        self.title = NSLocalizedString(@"Events.Title", nil);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    }
    
    return self;
}

@end
