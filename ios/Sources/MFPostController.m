/* Copyright (c) 2013 Meep Factory OU */

#import "MBProgressHUD.h"
#import "MFBrand.h"
#import "MFCondition.h"
#import "MFConditionController.h"
#import "MFImageView.h"
#import "MFListController.h"
#import "MFMediaGalleryController.h"
#import "MFMenu.h"
#import "MFMenuItem.h"
#import "MFPost.h"
#import "MFPostCommentsController.h"
#import "MFPostController.h"
#import "MFPostFooterView.h"
#import "MFPostHeaderView.h"
#import "MFPostSectionView.h"
#import "MFSize.h"
#import "MFWebPost.h"
#import "MFWebController.h"
#import "UIApplication+Additions.h"
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
                    MENU_ITEM_SUB(NSLocalizedString(@"Post.Action.SizeAndFit", nil), post.size.localizedName, @selector(sizeAndFit:), @"Post-SizeAndFit.png"),
                    MENU_ITEM_SUB(NSLocalizedString(@"Post.Action.Condition", nil), post.condition.title, @selector(condition:), @"Post-Condition.png"),
                    MENU_ITEM(NSLocalizedString(@"Post.Action.Material", nil), @selector(material:), @"Post-Material.png")),
                MENU_SECTION(NSLocalizedString(@"Post.Label.ShippingAndReturns", nil),
                    MENU_ITEM_SUB(NSLocalizedString(@"Post.Action.ShippingInfo", nil), NSLocalizedString(@"Post.Label.ShippingInfo", nil), @selector(shippingInfo:), @"Post-ShippingInfo.png"),
                    MENU_ITEM_SUB(NSLocalizedString(@"Post.Action.ReturnsPolicy", nil), NSLocalizedString(@"Post.Label.ReturnsPolicy", nil), @selector(returnsPolicy:), @"Post-Returns.png")),
                MENU_SECTION(NSLocalizedString(@"Post.Label.QAWithSeller", nil),
                    MENU_ITEM(NSLocalizedString(@"Post.Action.Comments", nil), @selector(comments:), @"Post-Comments.png")), nil];
    }
    
    return self;
}

@synthesize post = m_post;

- (UITableView *)tableView
{
    return (UITableView *)self.view;
}

- (IBAction)toggleCart:(id)sender
{
}

- (IBAction)sizeAndFit:(id)sender
{
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Size-And-Fit" title:((MFMenuItem *)sender).title lines:[m_post.post.fit componentsSeparatedByString:@"\n"]] animated:YES];
}

- (IBAction)condition:(id)sender
{
    [self.navigationController pushViewController:[[MFConditionController alloc] initWithCondition:m_post.condition] animated:YES];
}

- (IBAction)material:(id)sender
{
    [self.navigationController pushViewController:[[MFListController alloc] initWithTitle:((MFMenuItem *)sender).title lines:[m_post.post.materials componentsSeparatedByString:@"\n"]] animated:YES];
}

- (IBAction)shippingInfo:(id)sender
{
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Shipping-Info" title:((MFMenuItem *)sender).title] animated:YES];
}

- (IBAction)returnsPolicy:(id)sender
{
    [self.navigationController pushViewController:[[MFWebController alloc] initWithContentsOfFile:@"Returns-Policy" title:((MFMenuItem *)sender).title] animated:YES];
}

- (IBAction)comments:(id)sender
{
    [self.navigationController pushViewController:[[MFPostCommentsController alloc] initWithPost:m_post] animated:YES];
}

- (void)postDidChange:(NSNotification *)notification
{
}

#pragma mark MFPostFooterViewDelegate

- (void)headerView:(MFPostHeaderView *)headerView didSelectMedia:(NSString *)media
{
    MFMediaGalleryController *controller = [[MFMediaGalleryController alloc] init];
    MFPost *post = m_post.post;
    
    controller.mediaIds = post.mediaIds;
    controller.initialIndex = [post.mediaIds indexOfObject:media];
    
    [self.navigationController presentViewController:controller animated:YES completion:NULL];
    //[self.navigationController pushViewController:controller animated:YES];
}

#pragma mark MFPostFooterViewDelegate

- (void)footerViewDidSelectSave:(MFPostFooterView *)footerView
{
    BOOL saved = !m_post.saved;
    
    m_post.saved = saved;
    footerView.leftTitle = NSLocalizedString((saved) ? @"Post.Action.Unsave" : @"Post.Action.Save", nil);
}

- (void)footerViewDidSelectShare:(MFPostFooterView *)footerView
{
    [[UIApplication sharedApplication] sendEmail:nil
                                         subject:[NSString stringWithFormat:NSLocalizedString(@"Post.Format.Email.Subject", nil)]
                                            body:[NSString stringWithFormat:NSLocalizedString(@"Post.Format.Email.Body", nil)]];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL_IDENTIFIER];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Disclosure-Indicator.png"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont themeFontOfSize:13.0F];
        cell.detailTextLabel.font = [UIFont themeFontOfSize:13.0F];
    }
    
    cell.imageView.image = (item.image) ? [UIImage imageNamed:item.image] : nil;
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subtitle;
    
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

#pragma mark UIViewController

- (void)loadView
{
    MFPostHeaderView *headerView = [[MFPostHeaderView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFPostHeaderView preferredHeight])];
    MFPostFooterView *footerView = [[MFPostFooterView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFPostFooterView preferredHeight])];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
    headerView.delegate = self;
    footerView.delegate = self;
    footerView.leftTitle = NSLocalizedString((m_post.saved) ? @"Post.Action.Unsave" : @"Post.Action.Save", nil);
    
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
    
    headerView.post = m_post.post;
    [m_post startLoading];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(postDidChange:) name:MFWebPostDidChangeNotification object:m_post];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center removeObserver:self name:MFWebPostDidChangeNotification object:m_post];
    [super viewWillDisappear:animated];
}

@end
