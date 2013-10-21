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
#import "MFTableViewCell.h"
#import "MFWebPost.h"
#import "MFWebController.h"
#import "UIApplication+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UITableView+Additions.h"

#define CELL_IDENTIFIER @"cell"

#define TAG_TABLEVIEW 1000

#define ALERT_LOAD 10
#define ALERT_OPEN 11

@implementation MFPostController

- (id)initWithPost:(MFWebPost *)post
{
    self = [super init];
    
    if(self) {
        MFBrand *brand = post.brand;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString((post.insideCart) ? @"Post.Action.RemoveFromCart" : @"Post.Action.AddToCart", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(toggleCart:)];
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
                //MENU_SECTION(NSLocalizedString(@"Post.Label.QAWithSeller", nil),
                //    MENU_ITEM(NSLocalizedString(@"Post.Action.Comments", nil), @selector(comments:), @"Post-Comments.png")),
                nil];
    }
    
    return self;
}

@synthesize post = m_post;

- (UITableView *)tableView
{
    return (UITableView *)[self.view viewWithTag:TAG_TABLEVIEW];
}

- (MFPostHeaderView *)headerView
{
    return (MFPostHeaderView *)self.tableView.tableHeaderView;
}

- (IBAction)toggleCart:(id)sender
{
    BOOL insideCart = !m_post.insideCart;
    
    m_post.insideCart = insideCart;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString((insideCart) ? @"Post.Action.RemoveFromCart" : @"Post.Action.AddToCart", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(toggleCart:)];
    
    if(insideCart) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Post.Alert.AddedToCart.Title", nil)
                                                            message:NSLocalizedString(@"Post.Alert.AddedToCart.Message", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"Post.Alert.AddedToCart.Action.OK", nil), nil];
        
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Post.Alert.RemovedFromCart.Title", nil)
                                                            message:NSLocalizedString(@"Post.Alert.RemovedFromCart.Message", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"Post.Alert.RemovedFromCart.Action.OK", nil), nil];
        
        [alertView show];
    }
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
    UITableView *tableView = self.tableView;
    
    if(tableView.hidden) {
        self.headerView.post = m_post.post;
        self.title = m_post.brand.name;
    }
}

- (void)postDidBeginLoading:(NSNotification *)notification
{
    if(!m_hudView) {
        m_hudView = [[MBProgressHUD alloc] initWithView:self.view];
        m_hudView.labelText = NSLocalizedString(@"Post.Label.Loading", nil);
        m_hudView.labelFont = [UIFont themeBoldFontOfSize:16.0F];
        m_hudView.detailsLabelFont = [UIFont themeBoldFontOfSize:12.0F];
        m_hudView.removeFromSuperViewOnHide = YES;
        [self.view addSubview:m_hudView];
        [m_hudView show:NO];
    }
}

- (void)postDidEndLoading:(NSNotification *)notification
{
    NSError *error = [notification.userInfo objectForKey:MFWebPostErrorKey];
    
    if(error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Post.Alert.LoadError.Title", nil)
                                                                message:NSLocalizedString(@"Post.Alert.LoadError.Message", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Post.Alert.LoadError.Action.Close", nil)
                                                      otherButtonTitles:NSLocalizedString(@"Post.Alert.LoadError.Action.Retry", nil), nil];
        
        alertView.tag = ALERT_LOAD;
        [alertView show];
    } else {
        UITableView *tableView = self.tableView;
        
        if(m_hudView) {
            NSString *message = nil;
            
            switch(m_post.post.status) {
                case kMFPostStatusDeleted:
                    message = NSLocalizedString(@"Post.Alert.OpenError.Message.Deleted", nil);
                    break;
                case kMFPostStatusUnlisted:
                case kMFPostStatusUnlistedBought:
                    if(!m_post.mine) {
                        message = NSLocalizedString(@"Post.Alert.OpenError.Message.Expired", nil);
                    }
                    break;
                default:
                    break;
            }
            
            if(message) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Post.Alert.OpenError.Title", nil)
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Post.Alert.OpenError.Action.OK", nil)
                                                      otherButtonTitles:nil];
                
                alertView.tag = ALERT_OPEN;
                [alertView show];
                [m_hudView hide:NO];
                m_hudView = nil;
                return;
            }
        }
        
        if(tableView.hidden) {
            tableView.hidden = NO;
            [tableView reloadData];
        }
        
        [m_hudView hide:YES];
        m_hudView = nil;
    }
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
    
    if(saved) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Post.Alert.Saved.Title", nil)
                                                            message:NSLocalizedString(@"Post.Alert.Saved.Message", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"Post.Alert.Saved.Action.OK", nil), nil];
        
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Post.Alert.Unsaved.Title", nil)
                                                            message:NSLocalizedString(@"Post.Alert.Unsaved.Message", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"Post.Alert.Unsaved.Action.OK", nil), nil];
        
        [alertView show];
    }
}

- (void)footerViewDidSelectShare:(MFPostFooterView *)footerView
{
    MFPost *post = m_post.post;
    MFBrand *brand = m_post.brand;
    NSString *subject = NSLocalizedString(@"Post.Format.Email.Subject", nil);
    NSString *body = NSLocalizedString(@"Post.Format.Email.Body", nil);
    NSString *link = [NSString stringWithFormat:@"http://relovedapp.co.uk/post/%@", post.identifier];
    
    subject = [subject stringByReplacingOccurrencesOfString:@"%%BRAND%%" withString:(brand) ? brand.name : @"???"];
    subject = [subject stringByReplacingOccurrencesOfString:@"%%TITLE%%" withString:post.title];
    
    body = [body stringByReplacingOccurrencesOfString:@"%%BRAND%%" withString:(brand) ? brand.name : @"???"];
    body = [body stringByReplacingOccurrencesOfString:@"%%TITLE%%" withString:post.title];
    body = [body stringByReplacingOccurrencesOfString:@"%%NOTES%%" withString:post.notes];
    body = [body stringByReplacingOccurrencesOfString:@"%%LINK%%" withString:link];
    
    [[UIApplication sharedApplication] sendEmail:nil
                                         subject:subject
                                            body:body];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch(alertView.tag) {
        case ALERT_LOAD:
            if(alertView.cancelButtonIndex != buttonIndex) {
                [m_post startLoading];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        case ALERT_OPEN:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
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
        cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL_IDENTIFIER];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Disclosure-Indicator.png"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont themeFontOfSize:13.0F];
        cell.detailTextLabel.font = [UIFont themeFontOfSize:13.0F];
        cell.backgroundNormalColor = [UIColor themeButtonBackgroundColor];
        cell.backgroundHighlightColor = [UIColor themeButtonBackgroundHighlightColor];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
    view.backgroundColor = [UIColor themeBackgroundColor];
    
    headerView.delegate = self;
    footerView.delegate = self;
    footerView.leftTitle = NSLocalizedString((m_post.saved) ? @"Post.Action.Unsave" : @"Post.Action.Save", nil);
    
    if([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        tableView.separatorInset = UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F);
    }
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = [UIColor themeBackgroundColor];
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = footerView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 45.0F;
    tableView.tag = TAG_TABLEVIEW;
    [view addSubview:tableView];
    
    self.view = view;
    
    if(m_post.loaded) {
        headerView.post = m_post.post;
    } else {
        tableView.hidden = YES;
    }
    
    [m_post startLoading];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(postDidBeginLoading:) name:MFWebPostDidBeginLoadingNotification object:m_post];
    [center addObserver:self selector:@selector(postDidEndLoading:) name:MFWebPostDidEndLoadingNotification object:m_post];
    [center addObserver:self selector:@selector(postDidChange:) name:MFWebPostDidChangeNotification object:m_post];
    [super viewWillAppear:animated];
    [self.tableView clearSelection];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center removeObserver:self name:MFWebPostDidBeginLoadingNotification object:m_post];
    [center removeObserver:self name:MFWebPostDidEndLoadingNotification object:m_post];
    [center removeObserver:self name:MFWebPostDidChangeNotification object:m_post];
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [m_post stopLoading];
}

@end
