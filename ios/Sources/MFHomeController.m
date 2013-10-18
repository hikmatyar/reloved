/* Copyright (c) 2013 Meep Factory OU */

#import "MFBookmarksController.h"
#import "MFBrowseController.h"
#import "MFBrowseFilterController.h"
#import "MFColor.h"
#import "MFDatabase+Color.h"
#import "MFDatabase+Post.h"
#import "MFDatabase+Type.h"
#import "MFHistoryController.h"
#import "MFHomeController.h"
#import "MFHomeFooterView.h"
#import "MFHomeHeaderView.h"
#import "MFHomeSectionView.h"
#import "MFMenu.h"
#import "MFMenuItem.h"
#import "MFOptionPickerController.h"
#import "MFPostController.h"
#import "MFProfileController.h"
#import "MFRecentsController.h"
#import "MFSearchController.h"
#import "MFSeparatorView.h"
#import "MFSideMenuContainerViewController.h"
#import "MFTableView.h"
#import "MFTableViewCell.h"
#import "MFType.h"
#import "MFWebController.h"
#import "MFWebFeed.h"
#import "MFWebPost.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UITableView+Additions.h"
#import "UIViewController+Additions.h"
#import "UIViewController+MFSideMenuAdditions.h"

#define CELL_IDENTIFIER @"cell"

@implementation MFHomeController

- (MFTableView *)tableView
{
    return (MFTableView *)self.view;
}

- (MFHomeHeaderView *)headerView
{
    return (MFHomeHeaderView *)self.tableView.tableHeaderView;
}

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

- (void)feedDidChange:(NSNotification *)notification
{
    if([MFWebFeed sharedFeed] == notification.object) {
        self.headerView.post = [MFDatabase sharedDatabase].featuredPost;
    }
}

#pragma mark MFHomeHeaderViewDelegate

- (void)headerViewDidSelectShopByColor:(MFHomeHeaderView *)headerView
{
#if 1
    MFBrowseFilterController *controller = [[MFBrowseFilterController alloc] initWithCategory:kMFBrowseFilterControllerCategoryColor];
    
    [self presentNavigableViewController:controller animated:YES completion:^() {
        [self.navigationController pushViewController:[[MFBrowseController alloc] initWithScope:kMFBrowseControllerScopeAll] animated:NO];
    }];
#else
    NSArray *colors = [MFDatabase sharedDatabase].colors;
    
    if(colors.count > 0) {
        MFOptionPickerController *controller = [[MFOptionPickerController alloc] init];
        NSMutableArray *colors_ = [[NSMutableArray alloc] initWithArray:colors];
        
        [colors_ insertObject:[[MFColor alloc] initWithName:NSLocalizedString(@"SearchByColor.Label.SelectAll", nil)] atIndex:0];
        
        controller.allowsMultipleSelection = YES;
        controller.maximumSelectedItems = 5;
        controller.delegate = self;
        controller.sectionHeaderTitle = NSLocalizedString(@"SearchByColor.Label.Header", nil);
        controller.items = colors_;
        controller.selectedItem = colors_.firstObject;
        controller.userInfo = [MFColor class];
        controller.title = NSLocalizedString(@"SearchByColor.Title", nil);
        controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SearchByColor.Action.Search", nil) style:UIBarButtonItemStyleBordered target:controller action:@selector(complete:)];
        [self.navigationController pushViewController:controller animated:YES];
    }
#endif
}

- (void)headerViewDidSelectShopByDress:(MFHomeHeaderView *)headerView
{
#if 1
    MFBrowseFilterController *controller = [[MFBrowseFilterController alloc] initWithCategory:kMFBrowseFilterControllerCategoryType];
    
    [self presentNavigableViewController:controller animated:YES completion:^() {
        [self.navigationController pushViewController:[[MFBrowseController alloc] initWithScope:kMFBrowseControllerScopeAll] animated:NO];
    }];
#else
    NSArray *types = [MFDatabase sharedDatabase].types;
    
    if(types.count > 0) {
        MFOptionPickerController *controller = [[MFOptionPickerController alloc] init];
        NSMutableArray *types_ = [[NSMutableArray alloc] initWithArray:types];
        
        [types_ insertObject:[[MFType alloc] initWithName:NSLocalizedString(@"SearchByType.Label.SelectAll", nil)] atIndex:0];
        
        controller.allowsMultipleSelection = YES;
        controller.maximumSelectedItems = 5;
        controller.delegate = self;
        controller.sectionHeaderTitle = NSLocalizedString(@"SearchByType.Label.Header", nil);
        controller.items = types_;
        controller.selectedItem = types_.firstObject;
        controller.userInfo = [MFType class];
        controller.title = NSLocalizedString(@"SearchByType.Title", nil);
        controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SearchByType.Action.Search", nil) style:UIBarButtonItemStyleBordered target:controller action:@selector(complete:)];
        [self.navigationController pushViewController:controller animated:YES];
    }
#endif
}

- (void)headerViewDidSelectShopByFeatured:(MFHomeHeaderView *)headerView
{
    MFPost *post = [MFDatabase sharedDatabase].featuredPost;
    
    if(post) {
        [self.navigationController pushViewController:[[MFPostController alloc] initWithPost:[[MFWebPost alloc] initWithPost:post]] animated:YES];
    }
}

#pragma mark MFOptionPickerController

- (BOOL)optionPickerController:(MFOptionPickerController *)controller mustSelectItem:(id)item
{
    return (controller.items.firstObject == item) ? YES : NO;
}

- (void)optionPickerControllerDidChange:(MFOptionPickerController *)controller atItem:(id)item
{
    NSSet *selectedItems = controller.selectedItems;
    NSArray *items = controller.items;
    id wildcard = items.firstObject;
    
    if(item == wildcard) {
        controller.selectedItem = wildcard;
    } else if([selectedItems containsObject:wildcard]) {
        NSMutableSet *selectedItems_ = [[NSMutableSet alloc] init];
        
        for(id selectedItem in selectedItems) {
            if(selectedItem != wildcard) {
                [selectedItems_ addObject:selectedItem];
            }
        }
        
        controller.selectedItems = selectedItems_;
    }
}

- (void)optionPickerControllerDidComplete:(MFOptionPickerController *)picker
{
    MFFeedController *controller = [[MFFeedController alloc] initWithFeed:[[MFWebFeed alloc] initWithFilters:picker.selectedItems.allObjects]];
    
    picker.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SearchResults.Action.Back", nil) style:UIBarButtonItemStylePlain target:nil action:NULL];
    controller.title = NSLocalizedString(@"SearchResults.Title", nil);
    controller.tableView.placeholder = NSLocalizedString(@"SearchResults.Label.NoData", nil);
    [picker.navigationController pushViewController:controller animated:YES];
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
    MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if(!cell) {
        cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Disclosure-Indicator.png"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundNormalColor = [UIColor themeButtonBackgroundColor];
        cell.backgroundHighlightColor = [UIColor themeButtonBackgroundHighlightColor];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView clearSelection];
    self.headerView.post = [MFDatabase sharedDatabase].featuredPost;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedDidChange:) name:MFWebFeedDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MFWebFeedDidChangeNotification object:nil];
    [super viewWillDisappear:animated];
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
