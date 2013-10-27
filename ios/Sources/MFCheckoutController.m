/* Copyright (c) 2013 Meep Factory OU */

#import "MBProgressHUD.h"
#import "MFCart.h"
#import "MFCheckout.h"
#import "MFCheckoutController.h"
#import "MFCheckoutController+Address.h"
#import "MFCheckoutController+Cart.h"
#import "MFCheckoutController+Confirm.h"
#import "MFCheckoutController+Payment.h"
#import "MFCheckoutPageView.h"
#import "MFCountry.h"
#import "MFCurrency.h"
#import "MFDatabase+Cart.h"
#import "MFDatabase+Country.h"
#import "MFDatabase+Delivery.h"
#import "MFDatabase+Post.h"
#import "MFDelivery.h"
#import "MFOrder.h"
#import "MFPageScrollView.h"
#import "MFPost.h"
#import "MFProgressView.h"
#import "MFMoney.h"
#import "MFNotice.h"
#import "MFNoticeController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFUserDetails.h"
#import "MFWebFeed.h"
#import "MFWebServiceError.h"
#import "MFWebService+Checkout.h"
#import "PKCard.h"
#import "STPCard.h"
#import "Stripe.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+Additions.h"
#import "UIViewController+MFSideMenuAdditions.h"

#define ALERT_ABORT 1
#define ALERT_ABORT_MENU 2
#define ALERT_STARTING 3
#define ALERT_ORDERING 4
#define ALERT_GENERIC 5

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

- (void)clearCart
{
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

- (void)requestCheckout
{
    MFDatabase *database = [MFDatabase sharedDatabase];
    NSDate *lastModification = nil;
    
    for(MFPost *post in [database postsForIdentifiers:m_cart.postIds]) {
        lastModification = (lastModification) ? [post.modified laterDate:lastModification] : post.modified;
    }
    
    [[MFWebService sharedService] requestCheckout:m_cart.postIds lastModification:lastModification target:self usingBlock:^(id target, NSError *error, MFCheckout *checkout) {
        // Allow to update global state
        if(checkout.posts > 0) {
            [database beginUpdates];
            
            for(MFPost *post in checkout.posts) {
                [database setPost:post forIdentifier:post.identifier];
            }
            
            [database endUpdates];
        }
        
        if(checkout.countries) {
            database.countries = checkout.countries;
        }
        
        if(checkout.deliveries) {
            database.deliveries = checkout.deliveries;
        }
        
        // Error handling
        if((checkout && checkout.status != kMFCheckoutStatusValid) ||
           (error && [error.domain isEqualToString:MFWebServiceErrorDomain] && error.code == kMFWebServiceErrorParameterInvalid)) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Checkout.Alert.StartingErrorBadItems.Title", nil)
                                                                message:NSLocalizedString(@"Checkout.Alert.StartingErrorBadItems.Message", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Checkout.Alert.StartingErrorBadItems.Action.OK", nil)
                                                      otherButtonTitles:nil];
            
            alertView.tag = ALERT_GENERIC;
            
            [alertView show];
        } else if(error || !checkout) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Checkout.Alert.StartingError.Title", nil)
                                                                message:NSLocalizedString(@"Checkout.Alert.StartingError.Message", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Checkout.Alert.StartingError.Action.Close", nil)
                                                      otherButtonTitles:NSLocalizedString(@"Checkout.Alert.StartingError.Action.Retry", nil), nil];
            
            alertView.tag = ALERT_STARTING;
            [alertView show];
        // Things look well
        } else {
            MFUserDetails *details = checkout.user;
            MFCurrency *currency = [MFCurrency gbp]; // TODO: Not correct
            __weak MFCheckoutController *controller = self;
            NSInteger price = 0;
            
            m_cart.firstName = details.firstName;
            m_cart.lastName = details.lastName;
            m_cart.countryId = details.countryId;
            m_cart.city = details.city;
            m_cart.address = details.address;
            m_cart.zipcode = details.zipcode;
            m_cart.email = details.email;
            m_cart.phone = details.phone;
            
            for(MFPost *post in [database postsForIdentifiers:m_cart.postIds]) {
                price += post.price;
            }
            
            m_cart.price = price;
            m_cart.transactionFee = [checkout feeForCurrency:currency.code].value;
            m_cart.amount = price + m_cart.transactionFee;
            m_cart.currency = currency.code;
            
            m_hud.completionBlock = ^() {
                [controller next:nil];
            };
            
            [m_hud hide:YES];
            m_hud = nil;
        }
    }];
}

- (void)requestOrderPayment
{
    PKCard *card = m_cart.card;
    
    m_hud.detailsLabelText = NSLocalizedString(@"Checkout.HUD.Ordering.Message1", nil);
    
    if(card) {
        STPCard *scard = [[STPCard alloc] init];
        
        scard.number = card.number;
        scard.expMonth = card.expMonth;
        scard.expYear = card.expYear;
        scard.cvc = card.cvc;
        
        [Stripe createTokenWithCard:scard publishableKey:STRIPE_KEY completion:^(STPToken *token, NSError *error) {
            if(error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Checkout.Alert.OrderingErrorPayment.Title", nil)
                                                                    message:NSLocalizedString(@"Checkout.Alert.OrderingErrorPayment.Message", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Checkout.Alert.OrderingErrorPayment.Action.Close", nil)
                                                          otherButtonTitles:NSLocalizedString(@"Checkout.Alert.OrderingErrorPayment.Action.Retry", nil), nil];
                
                alertView.tag = ALERT_ORDERING;
                [alertView show];
            } else {
                m_cart.stripeToken = token.tokenId;
                [self requestOrderCreate];
            }
        }];
    }
}

- (void)requestOrderCreate
{
    m_hud.detailsLabelText = NSLocalizedString(@"Checkout.HUD.Ordering.Message2", nil);
    
    [[MFWebService sharedService] requestOrderCreate:m_cart target:self usingBlock:^(id target, NSError *error, MFOrder *order) {
        // Error handling
        if(error && [error.domain isEqualToString:MFWebServiceErrorDomain] && error.code == kMFWebServiceErrorParameterInvalid) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Checkout.Alert.OrderingErrorDeclined.Title", nil)
                                                                message:NSLocalizedString(@"Checkout.Alert.OrderingErrorDeclined.Message", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Checkout.Alert.OrderingErrorDeclined.Action.OK", nil)
                                                      otherButtonTitles:nil];
            
            alertView.tag = ALERT_GENERIC;
            
            [alertView show];
        } else if(error || !order) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Checkout.Alert.OrderingError.Title", nil)
                                                                message:NSLocalizedString(@"Checkout.Alert.OrderingError.Message", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Checkout.Alert.OrderingError.Action.Close", nil)
                                                      otherButtonTitles:NSLocalizedString(@"Checkout.Alert.OrderingError.Action.Retry", nil), nil];
            
            alertView.tag = ALERT_ORDERING;
            [alertView show];
        // Things look well
        } else {
            m_cart.orderId = order.identifier;
            [self requestOrderResult];
        }
    }];
}

- (void)requestOrderResult
{
    if(m_hud && m_cart.orderId) {
        m_hud.detailsLabelText = NSLocalizedString(@"Checkout.HUD.Ordering.Message3", nil);
        
        [[MFWebService sharedService] requestOrderStatus:m_cart.orderId target:self usingBlock:^(id target, NSError *error, MFOrder *order) {
            if(error || !order) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Checkout.Alert.OrderingError.Title", nil)
                                                                    message:NSLocalizedString(@"Checkout.Alert.OrderingError.Message", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Checkout.Alert.OrderingError.Action.Close", nil)
                                                          otherButtonTitles:NSLocalizedString(@"Checkout.Alert.OrderingError.Action.Retry", nil), nil];
                
                alertView.tag = ALERT_ORDERING;
                [alertView show];
            } else {
                MFDatabase *database = [MFDatabase sharedDatabase];
                MFNotice *notice = order.notice;
                NSArray *posts;
                
                switch(order.status) {
                    case kMFOrderStatusPending:
                        [self performSelector:@selector(requestOrderResult) withObject:nil afterDelay:1.0F];
                        break;
                    case kMFOrderStatusAccepted:
                    case kMFOrderStatusCompleted:
                        posts = database.cart;
                        
                        if(notice) {
                            [self presentNavigableViewController:[[MFNoticeController alloc] initWithNotice:notice] animated:YES completion:NULL];
                        } else {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Checkout.Alert.Ordered.Title", nil)
                                                                                message:NSLocalizedString(@"Checkout.Alert.Ordered.Message", nil)
                                                                               delegate:self
                                                                      cancelButtonTitle:NSLocalizedString(@"Checkout.Alert.Ordered.Action.OK", nil)
                                                                      otherButtonTitles:nil];
                            
                            alertView.tag = ALERT_GENERIC;
                            [alertView show];
                        }
                        
                        database.cart = nil;
                        [self clearCart];
                        
                        for(MFPost *post in posts) {
                            MFMutablePost *_post = [posts mutableCopy];
                            
                            if([_post updateStatus:kMFPostStatusListedBought]) {
                                [database setPost:_post forIdentifier:_post.identifier];
                            }
                        }
                        break;
                    case kMFOrderStatusCancelled:
                    case kMFOrderStatusDeclined:
                    default:
                        if(notice) {
                            [self presentNavigableViewController:[[MFNoticeController alloc] initWithNotice:notice] animated:YES completion:NULL];
                        } else {
                            if(order.status == kMFOrderStatusCancelled) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Checkout.Alert.OrderingErrorCancelled.Title", nil)
                                                                                    message:NSLocalizedString(@"Checkout.Alert.OrderingErrorCancelled.Message", nil)
                                                                                   delegate:self
                                                                          cancelButtonTitle:NSLocalizedString(@"Checkout.Alert.OrderingErrorCancelled.Action.OK", nil)
                                                                          otherButtonTitles:nil];
                                
                                alertView.tag = ALERT_GENERIC;
                                [alertView show];
                            } else {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Checkout.Alert.OrderingErrorDeclined.Title", nil)
                                                                                    message:NSLocalizedString(@"Checkout.Alert.OrderingErrorDeclined.Message", nil)
                                                                                   delegate:self
                                                                          cancelButtonTitle:NSLocalizedString(@"Checkout.Alert.OrderingErrorDeclined.Action.OK", nil)
                                                                          otherButtonTitles:nil];
                                
                                alertView.tag = ALERT_GENERIC;
                                [alertView show];
                            }
                        }
                        
                        database.cart = nil;
                        [self clearCart];
                        break;
                }
            }
        }];
    }
}

- (void)requestOrder
{
    if(m_cart.orderId) {
        [self requestOrderResult];
    } else if(m_cart.stripeToken) {
        [self requestOrderCreate];
    } else {
        [self requestOrderPayment];
    }
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
    if([m_cart isReadyToSubmit]) {
        if(!m_hud) {
            m_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            m_hud.dimBackground = YES;
            m_hud.labelText = NSLocalizedString(@"Checkout.HUD.Ordering.Title", nil);
            m_hud.detailsLabelText = NSLocalizedString(@"Checkout.HUD.Ordering.Message1", nil);
            m_hud.minShowTime = 0.5F;
            [self.view addSubview:m_hud];
            [m_hud show:YES];
            [self requestOrder];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Checkout.Alert.ValidationError.Title", nil)
                                                            message:NSLocalizedString(@"Checkout.Alert.ValidationError.Message", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Checkout.Alert.ValidationError.Action.OK", nil)
                                                  otherButtonTitles:nil];
        
        [alertView show];
    }
}

- (IBAction)next:(id)sender
{
    MFProgressView *progressView = self.progressView;
    NSInteger index = progressView.selectedIndex;
    
    if(index != NSNotFound) {
        if(index + 1 < m_steps.count) {
            index += 1;
            
            if(index > 0 && m_cart.empty && m_cart.postIds.count > 0) {
                if(!m_hud) {
                    m_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    m_hud.dimBackground = YES;
                    m_hud.labelText = NSLocalizedString(@"Checkout.HUD.Starting.Title", nil);
                    m_hud.detailsLabelText = NSLocalizedString(@"Checkout.HUD.Starting.Message", nil);
                    m_hud.minShowTime = 0.5F;
                    [self.view addSubview:m_hud];
                    [m_hud show:YES];
                    [self requestCheckout];
                }
            } else if([self progressView:progressView shouldSelectItemAtIndex:index]) {
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
                
                if(![step canContinue] || (i == 0 && m_cart.empty)) {
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
                [self clearCart];
            }
            break;
        case ALERT_STARTING:
            if(buttonIndex != alertView.cancelButtonIndex) {
                [self requestCheckout];
            } else {
                [m_hud hide:YES];
                m_hud = nil;
            }
            break;
        case ALERT_ORDERING:
            if(buttonIndex != alertView.cancelButtonIndex) {
                [self requestOrder];
            } else {
                [m_hud hide:YES];
                m_hud = nil;
            }
            break;
        case ALERT_GENERIC:
            [m_hud hide:YES];
            m_hud = nil;
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
    
    [items addObject:NSLocalizedString(@"Checkout.Action.Receipt", nil)];
    
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
    [[MFWebService sharedService] cancelRequestsForTarget:self];
    m_stepIndex = self.progressView.selectedIndex;
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if(m_hud) {
        [m_hud removeFromSuperview];
        m_hud = nil;
    }
    
    [super viewDidDisappear:animated];
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
            STEP_ITEM(NSLocalizedString(@"Checkout.Action.Confirm", nil), NSLocalizedString(@"Checkout.Title.Confirm", nil), [self createConfirmPageView], NO), nil];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Checkout.Action.Next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(next:)];
    }
    
    return self;
}

@end
