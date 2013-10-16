/* Copyright (c) 2013 Meep Factory OU */

#import "MFBookmarksController.h"
#import "MFBrowseController.h"
#import "MFHistoryController.h"
#import "MFHomeController.h"
#import "MFHomeFooterView.h"
#import "MFHomeHeaderView.h"
#import "MFHomeSectionView.h"
#import "MFMenu.h"
#import "MFMenuItem.h"
#import "MFProfileController.h"
#import "MFRecentsController.h"
#import "MFSeparatorView.h"
#import "MFSideMenuContainerViewController.h"
#import "MFWebController.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+Additions.h"
#import "UIViewController+MFSideMenuAdditions.h"

#define CELL_IDENTIFIER @"cell"

@implementation MFHomeController

- (IBAction)browseEditorial:(id)sender
{
    [self.navigationController pushViewController:[[MFBrowseController alloc] initWithScope:kMFBrowseControllerScopeEditorial] animated:YES];
}

- (IBAction)browseNew:(id)sender
{
    [self.navigationController pushViewController:[[MFBrowseController alloc] initWithScope:kMFBrowseControllerScopeNew] animated:YES];
}

- (IBAction)browseAll:(id)sender
{
    [self.navigationController pushViewController:[[MFBrowseController alloc] initWithScope:kMFBrowseControllerScopeAll] animated:YES];
}

- (IBAction)bookmarks:(id)sender
{
    [self.navigationController pushViewController:[[MFBookmarksController alloc] init] animated:YES];
}

- (IBAction)recents:(id)sender
{
    [self.navigationController pushViewController:[[MFRecentsController alloc] init] animated:YES];
}

- (IBAction)profile:(id)sender
{
    [self presentNavigableViewController:[[MFProfileController alloc] init] animated:YES completion:NULL];
}

- (IBAction)history:(id)sender
{
    [self.navigationController pushViewController:[[MFHistoryController alloc] init] animated:YES];
}

- (IBAction)guarantee:(id)sender
{
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Guarantee" title:((MFMenuItem *)sender).title] animated:YES];
}

- (IBAction)returnsPolicy:(id)sender
{
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Returns-Policy" title:((MFMenuItem *)sender).title] animated:YES];
}

- (IBAction)shippingInfo:(id)sender
{
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Shipping-Info" title:((MFMenuItem *)sender).title] animated:YES];
}

- (IBAction)security:(id)sender
{
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Payment-Security" title:((MFMenuItem *)sender).title] animated:YES];
}

- (IBAction)about:(id)sender
{
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Contact-Us" title:((MFMenuItem *)sender).title] animated:YES];
}

- (IBAction)menu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
}

#pragma mark MFHomeHeaderViewDelegate

- (void)headerViewDidSelectShopByColor:(MFHomeHeaderView *)headerView
{
}

- (void)headerViewDidSelectShopByDress:(MFHomeHeaderView *)headerView
{
}

- (void)headerViewDidSelectShopByFeatured:(MFHomeHeaderView *)headerView
{
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_menu.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((MFMenu *)[m_menu objectAtIndex:section]).children.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFMenuItem *item = [[m_menu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Disclosure-Indicator.png"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont themeFontOfSize:13.0F];
    }
    
    cell.imageView.image = (item.image) ? [UIImage imageNamed:item.image] : nil;
    cell.textLabel.text = item.title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *title = ((MFMenu *)[m_menu objectAtIndex:section]).title;
    
    return (title) ? ((title.length > 1) ? 1.0F : 0.5F) * [MFHomeSectionView preferredHeight] : 0.0F;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    NSString *title = ((MFMenu *)[m_menu objectAtIndex:section]).title;
    
    return (title) ? [[MFHomeSectionView alloc] initWithTitle:title] : nil;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[m_menu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] activate:self];
}

#pragma mark UIView

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    MFHomeHeaderView *headerView = [[MFHomeHeaderView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFHomeHeaderView preferredHeight])];
    MFHomeFooterView *footerView = [[MFHomeFooterView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFHomeFooterView preferredHeight])];
    
    headerView.delegate = self;
    
    if([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        tableView.separatorInset = UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F);
    }
    
    tableView.backgroundColor = [UIColor themeBackgroundColor];
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = footerView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 45.0F;
    self.view = tableView;
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        m_menu = [[NSArray alloc] initWithObjects:
                MENU_SECTION(nil,
                    MENU_ITEM(NSLocalizedString(@"Home.Action.BrowseEditorial", nil), @selector(browseEditorial:), @"Home-BrowseEditorial.png")),
                MENU_SECTION(@" ",
                    MENU_ITEM(NSLocalizedString(@"Home.Action.BrowseNew", nil), @selector(browseNew:), @"Home-BrowseNew.png"),
                    MENU_ITEM(NSLocalizedString(@"Home.Action.BrowseAll", nil), @selector(browseAll:), @"Home-BrowseAll.png")),
                MENU_SECTION(NSLocalizedString(@"Home.Label.MyItems", nil),
                    MENU_ITEM(NSLocalizedString(@"Home.Action.Bookmarks", nil), @selector(bookmarks:), @"Home-Bookmarks.png"),
                    MENU_ITEM(NSLocalizedString(@"Home.Action.Recents", nil), @selector(recents:), @"Home-Recents.png")),
                MENU_SECTION(NSLocalizedString(@"Home.Label.MyAccount", nil),
                    MENU_ITEM(NSLocalizedString(@"Home.Action.Profile", nil), @selector(profile:), @"Home-Profile.png"),
                    MENU_ITEM(NSLocalizedString(@"Home.Action.History", nil), @selector(history:), @"Home-History.png")),
                MENU_SECTION(NSLocalizedString(@"Home.Label.CustomerCare", nil),
                    MENU_ITEM(NSLocalizedString(@"Home.Action.Guarantee", nil), @selector(guarantee:), @"Home-Guarantee.png"),
                    MENU_ITEM(NSLocalizedString(@"Home.Action.ReturnsPolicy", nil), @selector(returnsPolicy:), @"Home-ReturnsPolicy.png"),
                    MENU_ITEM(NSLocalizedString(@"Home.Action.ShippingInfo", nil), @selector(shippingInfo:), @"Home-ShippingInfo.png"),
                    MENU_ITEM(NSLocalizedString(@"Home.Action.Security", nil), @selector(security:), @"Home-Security.png"),
                    MENU_ITEM(NSLocalizedString(@"Home.Action.About", nil), @selector(about:), @"Home-About.png")), nil];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Home.Title", nil) style:UIBarButtonItemStyleBordered target:nil action:NULL];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Navigation-Logo"]]];
    }
    
    return self;
}

@end
