/* Copyright (c) 2013 Meep Factory OU */

#import "MFCheckoutController.h"
#import "MFCheckoutController+Address.h"
#import "MFCheckoutController+Cart.h"
#import "MFCheckoutController+Confirm.h"
#import "MFCheckoutController+Payment.h"
#import "MFCheckoutController+Receipt.h"
#import "MFCheckoutPageView.h"
#import "MFPageScrollView.h"
#import "MFProgressView.h"
#import "MFSideMenuContainerViewController.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+MFSideMenuAdditions.h"

#define TAG_PROGRESS_VIEW 1000
#define TAG_CONTENT_VIEW 1001

#define STEP_ITEM(l, t, p) [[MFCheckoutController_Step alloc] initWithLabel:l title:t page:p]

@interface MFCheckoutController_Step : NSObject
{
    @private
    NSString *m_label;
    NSString *m_title;
    MFCheckoutPageView *m_page;
}

- (id)initWithLabel:(NSString *)label title:(NSString *)title page:(MFCheckoutPageView *)page;

@property (nonatomic, retain, readonly) NSString *label;
@property (nonatomic, retain, readonly) MFCheckoutPageView *page;
@property (nonatomic, retain, readonly) NSString *title;

- (BOOL)canContinue;

@end

@implementation MFCheckoutController_Step

- (id)initWithLabel:(NSString *)label title:(NSString *)title page:(MFCheckoutPageView *)page
{
    self = [super init];
    
    if(self) {
        m_label = label;
        m_title = title;
        m_page = (page) ? page : [[MFCheckoutPageView alloc] initWithFrame:CGRectZero controller:nil];
    }
    
    return self;
}

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

- (MFPageScrollView *)contentView
{
    return (MFPageScrollView *)[self.view viewWithTag:TAG_CONTENT_VIEW];
}

- (MFProgressView *)progressView
{
    return (MFProgressView *)[self.view viewWithTag:TAG_PROGRESS_VIEW];
}

- (IBAction)menu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
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

#pragma mark MFProgressViewDelegate

- (BOOL)progressView:(MFProgressView *)progressView shouldSelectItemAtIndex:(NSInteger)index
{
    NSInteger oldIndex = progressView.selectedIndex;
    
    if(oldIndex != NSNotFound && index > oldIndex) {
        for(NSInteger i = oldIndex, c = index; i < c; i++) {
            MFCheckoutController_Step *step = [m_steps objectAtIndex:i];
            
            if(![step canContinue]) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)progressView:(MFProgressView *)progressView didSelectItemAtIndex:(NSInteger)index
{
    if(index >= 0 && index < m_steps.count) {
        MFPageScrollView *contentView = self.contentView;
        MFCheckoutController_Step *step = [m_steps objectAtIndex:index];
        
        [contentView setSelectedPage:step.page animated:YES];
        [self invalidateNavigation];
    }
}

#pragma mark UIView

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    MFProgressView *progressView = [[MFProgressView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFProgressView preferredHeight]) style:kMFProgressViewStyleCheckout];
    MFPageScrollView *contentView = [[MFPageScrollView alloc] initWithFrame:CGRectMake(0.0F, [MFProgressView preferredHeight], 320.0F, 480.0F - [MFProgressView preferredHeight])];
    NSMutableArray *items = [NSMutableArray array];
    NSMutableArray *pages = [NSMutableArray array];
    
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
    
    view.backgroundColor = [UIColor themeBackgroundColor];
    
    self.view = view;
    [self invalidateNavigation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    m_stepIndex = self.progressView.selectedIndex;
    [super viewWillDisappear:animated];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        m_stepIndex = 0;
        m_steps = [[NSArray alloc] initWithObjects:
            STEP_ITEM(NSLocalizedString(@"Checkout.Action.Cart", nil), NSLocalizedString(@"Checkout.Title.Cart", nil), [self createCartPageView]),
            STEP_ITEM(NSLocalizedString(@"Checkout.Action.Address", nil), NSLocalizedString(@"Checkout.Title.Address", nil), [self createAddressPageView]),
            STEP_ITEM(NSLocalizedString(@"Checkout.Action.Payment", nil), NSLocalizedString(@"Checkout.Title.Payment", nil), [self createPaymentPageView]),
            STEP_ITEM(NSLocalizedString(@"Checkout.Action.Confirm", nil), NSLocalizedString(@"Checkout.Title.Confirm", nil), [self createConfirmPageView]),
            STEP_ITEM(NSLocalizedString(@"Checkout.Action.Receipt", nil), NSLocalizedString(@"Checkout.Title.Receipt", nil), [self createReceiptPageView]), nil];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Checkout.Action.Next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(next:)];
    }
    
    return self;
}

@end