/* Copyright (c) 2013 Meep Factory OU */

#import "MFCartController.h"
#import "MFFeedController.h"
#import "MFHomeController.h"
#import "MFMenuController.h"
#import "MFSearchController.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define CELL_IDENTIFIER @"cell"
#define ITEM(t, s, i) [[MFMenuController_Item alloc] initWithTitle:t selector:s icon:i]

typedef void (*MFMenuControllerAction)(id target, SEL sel, id sender);

@interface MFMenuController_Item : NSObject
{
    @private
    NSString *m_icon;
    SEL m_selector;
    NSString *m_title;
}

- (id)initWithTitle:(NSString *)title selector:(SEL)selector icon:(NSString *)icon;

@property (nonatomic, retain) NSString *icon;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, retain) NSString *title;

@end

@implementation MFMenuController_Item

- (id)initWithTitle:(NSString *)title selector:(SEL)selector icon:(NSString *)icon
{
    self = [super init];
    
    if(self) {
        m_icon = icon;
        m_selector = selector;
        m_title = title;
    }
    
    return self;
}

@synthesize icon = m_icon;
@synthesize selector = m_selector;
@synthesize title = m_title;

@end

#pragma mark -

@implementation MFMenuController

- (UITableView *)tableView
{
    return (UITableView *)self.view;
}

- (IBAction)home:(id)sender
{
}

- (IBAction)search:(id)sender
{
}

- (IBAction)news:(id)sender
{
}

- (IBAction)cart:(id)sender
{
}

- (IBAction)sell:(id)sender
{
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFMenuController_Item *item = [m_menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont themeBoldFontOfSize:18.0F];
    }
    
    cell.imageView.image = (item.icon) ? [UIImage imageNamed:item.icon] : nil;
    cell.textLabel.text = item.title;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFMenuController_Item *item = [m_menu objectAtIndex:indexPath.row];
    MFMenuControllerAction imp = (MFMenuControllerAction)[self methodForSelector:item.selector];
    
    imp(self, item.selector, nil);
}

#pragma mark UIView

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) style:UITableViewStylePlain];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 48.0F;
    
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
                  ITEM(NSLocalizedString(@"Menu.Action.Home", nil), @selector(home:), @"Menu-Home.png"),
                  ITEM(NSLocalizedString(@"Menu.Action.Search", nil), @selector(search:), @"Menu-Search.png"),
                  ITEM(NSLocalizedString(@"Menu.Action.News", nil), @selector(news:), @"Menu-News.png"),
                  ITEM(NSLocalizedString(@"Menu.Action.Cart", nil), @selector(cart:), @"Menu-Cart.png"),
                  ITEM(NSLocalizedString(@"Menu.Action.Sell", nil), @selector(sell:), @"Menu-Sell.png"), nil];
    }
    
    return self;
}

@end
