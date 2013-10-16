/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrand.h"
#import "MFMenu.h"
#import "MFMenuItem.h"
#import "MFPost.h"
#import "MFPostController.h"
#import "MFPostFooterView.h"
#import "MFPostHeaderView.h"
#import "MFPostSectionView.h"
#import "MFSize.h"
#import "MFWebPost.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define CELL_IDENTIFIER @"cell"

@implementation MFPostController

- (id)initWithPost:(MFWebPost *)post
{
    self = [super init];
    
    if(self) {
        MFBrand *brand = post.brand;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Post.Action.AddToCart", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(toggleCart:)];
        self.title = brand.name;
        
        m_post = post;
        m_menu = [[NSArray alloc] initWithObjects:
                MENU_SECTION(NSLocalizedString(@"Post.Label.AboutThisDress", nil),
                    MENU_ITEM(NSLocalizedString(@"Post.Action.SizeAndFit", nil), @selector(sizeAndFit:), @"Post-SizeAndFit.png"),
                    MENU_ITEM(NSLocalizedString(@"Post.Action.Condition", nil), @selector(condition:), @"Post-Condition.png"),
                    MENU_ITEM(NSLocalizedString(@"Post.Action.Description", nil), @selector(description:), @"Post-Description.png")),
                MENU_SECTION(NSLocalizedString(@"Post.Label.ShippingAndReturns", nil),
                    MENU_ITEM(NSLocalizedString(@"Post.Action.ShippingInfo", nil), @selector(shippingInfo:), @"Post-ShippingInfo.png"),
                    MENU_ITEM(NSLocalizedString(@"Post.Action.ReturnsPolicy", nil), @selector(returnsPolicy:), @"Post-Returns.png")),
                MENU_SECTION(NSLocalizedString(@"Post.Label.QAWithSeller", nil),
                    MENU_ITEM(NSLocalizedString(@"Post.Action.Comments", nil), @selector(comments:), @"Post-Comments.png")), nil];
    }
    
    return self;
}

- (UITableView *)tableView
{
    return (UITableView *)self.view;
}

- (IBAction)toggleCart:(id)sender
{
    
}

- (IBAction)sizeAntFit:(id)sender
{
}

- (IBAction)condition:(id)sender
{
}

- (IBAction)description:(id)sender
{
}

- (IBAction)shippingInfo:(id)sender
{
}

- (IBAction)returnsPolicy:(id)sender
{
}

- (IBAction)comments:(id)sender
{
}

#pragma mark MFPostFooterViewDelegate

- (void)footerViewDidSelectSave:(MFPostFooterView *)footerView
{
}

- (void)footerViewDidSelectShare:(MFPostFooterView *)footerView
{
}

- (void)footerViewDidSelectAddToCart:(MFPostFooterView *)footerView
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
    
    return (title) ? ((title.length > 1) ? 1.0F : 0.5F) * [MFPostSectionView preferredHeight] : 0.0F;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    NSString *title = ((MFMenu *)[m_menu objectAtIndex:section]).title;
    
    return (title) ? [[MFPostSectionView alloc] initWithTitle:title] : nil;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[m_menu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] activate:self];
}

#pragma mark UIView

- (void)loadView
{
    MFPostHeaderView *headerView = [[MFPostHeaderView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFPostHeaderView preferredHeight])];
    MFPostFooterView *footerView = [[MFPostFooterView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFPostFooterView preferredHeight])];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
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

@end
