/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormAccessory.h"
#import "MFSearchController.h"
#import "MFSideMenuContainerViewController.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+MFSideMenuAdditions.h"

#define CELL_IDENTIFIER @"cell"

#define TAG_TABLEVIEW 1000

@implementation MFSearchController

- (UITableView *)tableView
{
    return (UITableView *)[self.view viewWithTag:TAG_TABLEVIEW];
}

- (IBAction)menu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
}

- (IBAction)close:(id)sender
{
    [self.navigationItem.titleView resignFirstResponder];
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *term = searchBar.text.stringByTrimmingWhitespace;
    
    if(term.length > 2) {
        
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        cell.backgroundColor = [UIColor themeTextBackgroundColor];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Disclosure-Indicator.png"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indentationWidth = 12.0F;
        cell.indentationLevel = 1;
        cell.textLabel.font = [UIFont themeFontOfSize:14.0F];
        cell.textLabel.textColor = [UIColor themeTextColor];
    }
    
    cell.textLabel.text = @"#hello";
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark UIViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) style:UITableViewStylePlain];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 58.0F;
    tableView.backgroundColor = [UIColor themeTextBackgroundColor];
    tableView.separatorColor = [UIColor themeSeparatorColor];
    tableView.allowsMultipleSelection = NO;
    
    if([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        tableView.separatorInset = UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F);
    }
    
    view.backgroundColor = [UIColor themeTextBackgroundColor];
    [view addSubview:tableView];
    self.view = view;
    
    [m_accessory deactivate];
    m_accessory = [[MFFormAccessory alloc] initWithContext:tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [m_accessory activate];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [m_accessory deactivate];
    [super viewWillDisappear:animated];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 200.0F, 40.0F)];
        
        searchBar.delegate = self;
        searchBar.placeholder = NSLocalizedString(@"SearchResults.Hint.TypeHere", nil);
        self.navigationItem.titleView = searchBar;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SearchResults.Action.Cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(close:)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    return self;
}

@end
