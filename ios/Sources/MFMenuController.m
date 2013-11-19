/* Copyright (c) 2013 Meep Factory OU */

#import "MFCheckoutController.h"
#import "MFEventsController.h"
#import "MFFeedController.h"
#import "MFHomeController.h"
#import "MFMenuController.h"
#import "MFMenuItem.h"
#import "MFNewPostController.h"
#import "MFSearchController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFTableViewCell.h"
#import "NSDictionary+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UITableView+Additions.h"
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
    [self setViewControllerClass:[MFEventsController class]];
}

- (IBAction)cart:(id)sender
{
    [self setViewControllerClass:[MFCheckoutController class]];
}

- (IBAction)sell:(id)sender
{
    [self setViewControllerClass:[MFNewPostController class]];
}

- (void)menuStateDidChange:(NSNotification *)notification
{
    MFSideMenuStateEvent event = [notification.userInfo integerForKey:@"eventType"];
    
    if(event == MFSideMenuStateEventMenuDidClose) {
        [self.tableView clearSelection];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFMenuItem *item = [m_menu objectAtIndex:indexPath.row];
    MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if(!cell) {
        UIView *separatorView;
        
        cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundNormalColor = [UIColor themeMenuBackgroundColor];
        cell.backgroundHighlightColor = [UIColor themeMenuBackgroundHighlightColor];
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
    [super viewWillAppear:animated];
    [self.tableView clearSelection];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuStateDidChange:) name:MFSideMenuStateNotificationEvent object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MFSideMenuStateNotificationEvent object:nil];
    [super viewWillDisappear:animated];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        m_menu = [[NSArray alloc] initWithObjects:
                  MENU_ITEM(NSLocalizedString(@"Menu.Action.Home", nil), @selector(home:), @"Menu-Home.png"),
                  //MENU_ITEM(NSLocalizedString(@"Menu.Action.Search", nil), @selector(search:), @"Menu-Search.png"),
                  //MENU_ITEM(NSLocalizedString(@"Menu.Action.News", nil), @selector(news:), @"Menu-News.png"),
                  MENU_ITEM(NSLocalizedString(@"Menu.Action.Cart", nil), @selector(cart:), @"Menu-Cart.png"), nil];
        
        
    }
    
    return self;
}

@end
