/* Copyright (c) 2013 Meep Factory OU */

#import "MBProgressHUD.h"
#import "MFCart.h"
#import "MFCheckoutController.h"
#import "MFCheckoutController+Address.h"
#import "MFCheckoutController+Cart.h"
#import "MFCheckoutController+Confirm.h"
#import "MFCheckoutController+Payment.h"
#import "MFCheckoutController+Receipt.h"
#import "MFCheckoutPageView.h"
#import "MFDatabase+Cart.h"
#import "MFPageScrollView.h"
#import "MFPost.h"
#import "MFProgressView.h"
#import "MFNotice.h"
#import "MFNoticeController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFWebFeed.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+Additions.h"
#import "UIViewController+MFSideMenuAdditions.h"

#define ALERT_ABORT 1
#define ALERT_ABORT_MENU 2

#define TAG_PROGRESS_VIEW 1000
#define TAG_CONTENT_VIEW 1001
#define TAG_EMPTY_VIEW 1002

#define STEP_ITEM(l, t, p, f) [[MFCheckoutController_Step alloc] initWithLabel:l title:t page:p abort:f]

@interface MFCheckoutController_Step : NSObject
{
    @private
    BOOL m_abort;
    NSString *m_label;
    NSString *m_title;
    MFCheckoutPageView *m_page;
}

- (id)initWithLabel:(NSString *)label title:(NSString *)title page:(MFCheckoutPageView *)page abort:(BOOL)abort;

@property (nonatomic, assign, readonly) BOOL abort;
@property (nonatomic, retain, readonly) NSString *label;
@property (nonatomic, retain) MFCheckoutPageView *page;
@property (nonatomic, retain, readonly) NSString *title;

- (BOOL)canContinue;

@end

@implementation MFCheckoutController_Step

- (id)initWithLabel:(NSString *)label title:(NSString *)title page:(MFCheckoutPageView *)page abort:(BOOL)abort
{
    self = [super init];
    
    if(self) {
        m_abort = abort;
        m_label = label;
        m_title = title;
        m_page = (page) ? page : [[MFCheckoutPageView alloc] initWithFrame:CGRectZero controller:nil];
    }
    
    return self;
}

@synthesize abort = m_abort;
@synthesize label = m_label;
@synthesize page = m_page;
@synthesize title = m_title;

- (BOOL)canContinue
{
    return [m_page canContinue];
}

@end

#pragma mark -

@implementation MFCheckoutController

@synthesize cart = m_cart;

- (MFPageScrollView *)contentView
{
    return (MFPageScrollView *)[self.view viewWithTag:TAG_CONTENT_VIEW];
}

- (MFProgressView *)progressView
{
    return (MFProgressView *)[self.view viewWithTag:TAG_PROGRESS_VIEW];
}

- (UIView *)emptyView
{
    return [self.view viewWithTag:TAG_EMPTY_VIEW];
}

- (void)confirmAbort:(BOOL)menu
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Checkout.Alert.ConfirmAbort.Title", nil)
                                                            message:NSLocalizedString(@"Checkout.Alert.ConfirmAbort.Message", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Checkout.Alert.ConfirmAbort.Action.No", nil)
                                                  otherButtonTitles:NSLocalizedString(@"Checkout.Alert.ConfirmAbort.Action.Yes", nil), nil];
    
    alertView.tag = (menu) ? ALERT_ABORT_MENU : ALERT_ABORT;
    [alertView show];
}

- (IBAction)menu:(id)sender
{
    NSInteger index = self.progressView.selectedIndex;
    
    if(index > 0) {
        [self confirmAbort:YES];
    } else {
        [self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
    }
}

- (IBAction)done:(id)sender
{
}

- (IBAction)next:(id)sender
{
    MFProgressView *progressView = self.progressView;
    NSInteger index = progressView.selectedIndex;
    
    if(index != NSNotFound) {
        if(index + 1 < m_steps.count) {
            index += 1;
            
            if([self progressView:progressView shouldSelectItemAtIndex:index]) {
                progressView.selectedIndex = index;
                [self progressView:progressView didSelectItemAtIndex:index];
            }
        } else if([(MFCheckoutController_Step *)[m_steps objectAtIndex:m_steps.count - 1] canContinue]) {
            [self done:nil];
        }
    }
}

- (void)invalidateNavigation
{
    BOOL empty = (m_cart.postIds.count == 0) ? YES : NO;
    
    if(empty) {
        UIBarButtonItem *item = (UIBarButtonItem *)self.navigationItem.rightBarButtonItem;
        
        self.navigationItem.title = NSLocalizedString(@"Checkout.Title.Cart", nil);
        
        item.title = @"";
        item.enabled = NO;
        item.style = UIBarButtonItemStylePlain;
    } else {
        NSInteger index = self.progressView.selectedIndex;
        
        if(index != NSNotFound && index < m_steps.count) {
            UIBarButtonItem *item = (UIBarButtonItem *)self.navigationItem.rightBarButtonItem;
            
            self.navigationItem.title = ((MFCheckoutController_Step *)[m_steps objectAtIndex:index]).title;
            
            if(index + 1 >= m_steps.count) {
                item.title = NSLocalizedString(@"Checkout.Action.Done", nil);
                item.enabled = YES;
                item.style = UIBarButtonItemStyleDone;
            } else {
                item.title = NSLocalizedString(@"Checkout.Action.Next", nil);
                item.enabled = [(MFCheckoutController_Step *)[m_steps objectAtIndex:index] canContinue];
                item.style = UIBarButtonItemStylePlain;
            }
        }
    }
}

- (void)feedDidChange:(NSNotification *)notification
{
    MFWebFeed *feed = [MFWebFeed sharedFeedOfKind:kMFWebFeedKindCart];
    
    if(!notification || notification.object == feed) {
        NSMutableArray *postIds = [NSMutableArray array];
        NSArray *posts = feed.posts;
        
        for(MFPost *post in posts) {
            [postIds addObject:post.identifier];
        }
        
        if(!MFEqual(m_cart.postIds, postIds)) {
            m_cart.postIds = postIds;
            
            if(postIds.count > 0) {
                self.progressView.hidden = NO;
                self.contentView.hidden = NO;
                self.emptyView.hidden = YES;
            } else {
                self.progressView.hidden = YES;
                self.contentView.hidden = YES;
                self.emptyView.hidden = NO;
            }
        }
        
        for(MFCheckoutController_Step *step in m_steps) {
            [step.page cartDidChange];
        }
        
        [self invalidateNavigation];
    }
}

#pragma mark MFProgressViewDelegate

- (BOOL)progressView:(MFProgressView *)progressView shouldSelectItemAtIndex:(NSInteger)index
{
    NSInteger oldIndex = progressView.selectedIndex;
    
    if(oldIndex != NSNotFound) {
        if(index > oldIndex) {
            for(NSInteger i = oldIndex, c = index; i < c; i++) {
                MFCheckoutController_Step *step = [m_steps objectAtIndex:i];
                
                if(![step canContinue]) {
                    return NO;
                }
            }
        } else if(((MFCheckoutController_Step *)[m_steps objectAtIndex:oldIndex]).abort) {
            [self confirmAbort:NO];
            
            return NO;
        }
    }
    
    return YES;
}

- (void)progressView:(MFProgressView *)progressView didSelectItemAtIndex:(NSInteger)index
{
    if(index >= 0 && index < m_steps.count) {
        MFPageScrollView *contentView = self.contentView;
        MFCheckoutController_Step *step = [m_steps objectAtIndex:index];
        
        [contentView setSelectedPage:step.page animated:(progressView) ? YES : NO];
        [self invalidateNavigation];
    }
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch(alertView.tag) {
        case ALERT_ABORT_MENU:
            if(buttonIndex != alertView.cancelButtonIndex) {
                [self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
            }
        case ALERT_ABORT:
            if(buttonIndex != alertView.cancelButtonIndex) {
                NSMutableArray *pages = [[NSMutableArray alloc] init];
                MFProgressView *progressView = self.progressView;
                MFPageScrollView *contentView = self.contentView;
                
                m_cart = [[MFMutableCart alloc] init];
                
                progressView.selectedIndex = 0;
                [self progressView:nil didSelectItemAtIndex:0];
                
                [pages addObject:((MFCheckoutController_Step *)[m_steps objectAtIndex:0]).page];
                
                for(NSInteger i = 1, c = m_steps.count; i < c; i++) {
                    MFCheckoutController_Step *step = [m_steps objectAtIndex:i];
                    MFCheckoutPageView *page = [step.page createFreshView];
                    
                    step.page = page;
                    [pages addObject:page];
                }
                
                contentView.selectedPage = 0;
                contentView.pages = pages;
                
                [self feedDidChange:nil];
            }
            break;
    }
}

#pragma mark UIView

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    MFProgressView *progressView = [[MFProgressView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFProgressView preferredHeight]) style:kMFProgressViewStyleCheckout];
    MFPageScrollView *contentView = [[MFPageScrollView alloc] initWithFrame:CGRectMake(0.0F, [MFProgressView preferredHeight], 320.0F, 480.0F - [MFProgressView preferredHeight])];
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    NSMutableArray *items = [NSMutableArray array];
    NSMutableArray *pages = [NSMutableArray array];
    UILabel *label;
    
    for(MFCheckoutController_Step *step in m_steps) {
        [items addObject:step.label];
        [pages addObject:step.page];
    }
    
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    progressView.delegate = self;
    progressView.items = items;
    progressView.selectedIndex = m_stepIndex;
    progressView.tag = TAG_PROGRESS_VIEW;
    [view addSubview:progressView];
    
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.pages = pages;
    contentView.tag = TAG_CONTENT_VIEW;
    contentView.selectedPage = [pages objectAtIndex:m_stepIndex];
    [view addSubview:contentView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0F, 220.0F, 320.0F, 22.0F)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont themeFontOfSize:18.0F];
    label.text = NSLocalizedString(@"Checkout.Label.NoData", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor themeTextAlternativeColor];
    [emptyView addSubview:label];
    
    emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    emptyView.hidden = YES;
    emptyView.tag = TAG_EMPTY_VIEW;
    [view addSubview:emptyView];
    
    view.backgroundColor = [UIColor themeBackgroundColor];
    
    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedDidChange:) name:MFWebFeedDidChangeNotification object:nil];
    [self feedDidChange:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MFWebFeedDidChangeNotification object:nil];
    m_stepIndex = self.progressView.selectedIndex;
    [super viewWillDisappear:animated];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        m_cart = [[MFMutableCart alloc] init];
        m_stepIndex = 0;
        m_steps = [[NSArray alloc] initWithObjects:
            STEP_ITEM(NSLocalizedString(@"Checkout.Action.Cart", nil), NSLocalizedString(@"Checkout.Title.Cart", nil), [self createCartPageView], NO),
            STEP_ITEM(NSLocalizedString(@"Checkout.Action.Address", nil), NSLocalizedString(@"Checkout.Title.Address", nil), [self createAddressPageView], NO),
            STEP_ITEM(NSLocalizedString(@"Checkout.Action.Payment", nil), NSLocalizedString(@"Checkout.Title.Payment", nil), [self createPaymentPageView], NO),
            STEP_ITEM(NSLocalizedString(@"Checkout.Action.Confirm", nil), NSLocalizedString(@"Checkout.Title.Confirm", nil), [self createConfirmPageView], NO),
            STEP_ITEM(NSLocalizedString(@"Checkout.Action.Receipt", nil), NSLocalizedString(@"Checkout.Title.Receipt", nil), [self createReceiptPageView], NO), nil];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Checkout.Action.Next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(next:)];
    }
    
    return self;
}

@end
