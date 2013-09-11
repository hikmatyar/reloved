/* Copyright (c) 2013 Meep Factory OU */

#import "MFHomeController.h"
#import "MFMenu.h"
#import "MFMenuItem.h"
#import "MFSideMenuContainerViewController.h"
#import "MFWebController.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+MFSideMenuAdditions.h"

#define CELL_IDENTIFIER @"cell"

@implementation MFHomeController

- (IBAction)browseEditorial:(id)sender
{
}

- (IBAction)browseNew:(id)sender
{
}

- (IBAction)browseAll:(id)sender
{
}

- (IBAction)bookmarks:(id)sender
{
}

- (IBAction)recents:(id)sender
{
}

- (IBAction)profile:(id)sender
{
}

- (IBAction)history:(id)sender
{
}

- (IBAction)guarantee:(id)sender
{
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Guarantee"] animated:YES];
}

- (IBAction)returnsPolicy:(id)sender
{
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Returns-Policy"] animated:YES];
}

- (IBAction)shippingInfo:(id)sender
{
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Shipping-Info"] animated:YES];
}

- (IBAction)security:(id)sender
{
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Payment-Security"] animated:YES];
}

- (IBAction)about:(id)sender
{
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Contact-Us"] animated:YES];
}

- (IBAction)menu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont themeBoldFontOfSize:18.0F];
    }
    
    cell.imageView.image = (item.image) ? [UIImage imageNamed:item.image] : nil;
    cell.textLabel.text = item.title;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = ((MFMenu *)[m_menu objectAtIndex:section]).title;
    
    return (title) ? title : @" ";
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFMenuItem *item = [[m_menu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    MFMenuItemAction imp = (MFMenuItemAction)[self methodForSelector:item.selector];
    
    imp(self, item.selector, nil);
}

#pragma mark UIView

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
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
                MENU_SECTION(nil,
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
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
    }
    
    return self;
}

@end
