/* Copyright (c) 2013 Meep Factory OU */

#import "MFCartController.h"
#import "MFFeedController.h"
#import "MFHomeController.h"
#import "MFMenuController.h"
#import "MFMenuItem.h"
#import "MFNewPostController.h"
#import "MFNewsController.h"
#import "MFSearchController.h"
#import "MFSideMenuContainerViewController.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+MFSideMenuAdditions.h"

#define CELL_IDENTIFIER @"cell"

@implementation MFMenuController

- (UITableView *)tableView
{
    return (UITableView *)self.view;
}

- (void)setViewControllerClass:(Class)klass
{
    MFSideMenuContainerViewController *controller = self.menuContainerViewController;
    
    if(![((Class)((UINavigationController *)controller.centerViewController).viewControllers.firstObject).class isEqual:klass]) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[klass alloc] init]];
        
        navigationController.navigationBar.translucent = NO;
        controller.centerViewController = navigationController;
    }
    
    [controller toggleLeftSideMenuCompletion:NULL];
}

- (IBAction)home:(id)sender
{
    [self setViewControllerClass:[MFHomeController class]];
}

- (IBAction)search:(id)sender
{
    [self setViewControllerClass:[MFSearchController class]];
}

- (IBAction)news:(id)sender
{
    [self setViewControllerClass:[MFNewsController class]];
}

- (IBAction)cart:(id)sender
{
    [self setViewControllerClass:[MFCartController class]];
}

- (IBAction)sell:(id)sender
{
    [self setViewControllerClass:[MFNewPostController class]];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFMenuItem *item = [m_menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if(!cell) {
        UIView *separatorView;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor themeMenuBackgroundColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor themeMenuTextColor];
        cell.textLabel.font = [UIFont themeBoldFontOfSize:18.0F];
        
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, cell.contentView.frame.size.height - 1.0F, 320.0F, 1.0F)];
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        separatorView.backgroundColor = [UIColor themeMenuSeparatorColor];
        [cell.contentView addSubview:separatorView];
    }
    
    cell.imageView.image = (item.image) ? [UIImage imageNamed:item.image] : nil;
    cell.textLabel.text = item.title;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFMenuItem *item = [m_menu objectAtIndex:indexPath.row];
    MFMenuItemAction imp = (MFMenuItemAction)[self methodForSelector:item.selector];
    
    imp(self, item.selector, nil);
}

#pragma mark UIView

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) style:UITableViewStylePlain];
    
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 6.0F)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 66.0F;
    tableView.backgroundColor = [UIColor themeMenuBackgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view = tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    UITableView *tableView = self.tableView;
    NSIndexPath *selection = tableView.indexPathForSelectedRow;
    
    if(selection) {
        [tableView deselectRowAtIndexPath:selection animated:NO];
    }
    
    [super viewWillAppear:animated];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        m_menu = [[NSArray alloc] initWithObjects:
                  MENU_ITEM(NSLocalizedString(@"Menu.Action.Home", nil), @selector(home:), @"Menu-Home.png"),
                  MENU_ITEM(NSLocalizedString(@"Menu.Action.Search", nil), @selector(search:), @"Menu-Search.png"),
                  MENU_ITEM(NSLocalizedString(@"Menu.Action.News", nil), @selector(news:), @"Menu-News.png"),
                  MENU_ITEM(NSLocalizedString(@"Menu.Action.Cart", nil), @selector(cart:), @"Menu-Cart.png"),
                  MENU_ITEM(NSLocalizedString(@"Menu.Action.Sell", nil), @selector(sell:), @"Menu-Sell.png"), nil];
    }
    
    return self;
}

@end
