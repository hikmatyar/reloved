/* Copyright (c) 2013 Meep Factory OU */

#import "MBProgressHUD.h"
#import "MFNewPostController.h"
#import "MFNewPostController+Condition.h"
#import "MFNewPostController+Details.h"
#import "MFNewPostController+Photos.h"
#import "MFNewPostController+Price.h"
#import "MFNewPostController+Notes.h"
#import "MFNewPostController+TypeSizeAndFit.h"
#import "MFNewPostPageView.h"
#import "MFPageScrollView.h"
#import "MFPost.h"
#import "MFPostDetails.h"
#import "MFPostController.h"
#import "MFProgressView.h"
#import "MFSideMenuContainerViewController.h"
#import "MFWebPost.h"
#import "MFWebService+Post.h"
#import "MFWebUpload.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+Additions.h"
#import "UIViewController+MFSideMenuAdditions.h"

#define ALERT_POSTING 1
#define ALERT_GENERIC 2
#define ALERT_GENERIC_CLEAR 3

#define TAG_PROGRESS_VIEW 1000
#define TAG_CONTENT_VIEW 1001

#define STEP_ITEM(l, t, p) [[MFNewPostController_Step alloc] initWithLabel:l title:t page:p]

@interface MFNewPostController_Step : NSObject
{
    @private
    NSString *m_label;
    NSString *m_title;
    MFNewPostPageView *m_page;
}

- (id)initWithLabel:(NSString *)label title:(NSString *)title page:(MFNewPostPageView *)page;

@property (nonatomic, retain, readonly) NSString *label;
@property (nonatomic, retain) MFNewPostPageView *page;
@property (nonatomic, retain, readonly) NSString *title;

- (BOOL)canContinue;

@end

@implementation MFNewPostController_Step

- (id)initWithLabel:(NSString *)label title:(NSString *)title page:(MFNewPostPageView *)page
{
    self = [super init];
    
    if(self) {
        m_label = label;
        m_title = title;
        m_page = (page) ? page : [[MFNewPostPageView alloc] initWithFrame:CGRectZero controller:nil];
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

@interface MFNewPostController_Photo : NSObject
{
    @private
    NSString *m_ticket;
    NSString *m_mediaId;
}

@property (nonatomic, retain) NSString *ticket;
@property (nonatomic, retain) NSString *mediaId;

@end

@implementation MFNewPostController_Photo

@synthesize ticket = m_ticket;
@synthesize mediaId = m_mediaId;

@end

#pragma mark -

@implementation MFNewPostController

- (MFPageScrollView *)contentView
{
    return (MFPageScrollView *)[self.view viewWithTag:TAG_CONTENT_VIEW];
}

- (MFProgressView *)progressView
{
    return (MFProgressView *)[self.view viewWithTag:TAG_PROGRESS_VIEW];
}

@synthesize post = m_post;

- (IBAction)menu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
}

- (void)clearPost
{
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    MFProgressView *progressView = self.progressView;
    MFPageScrollView *contentView = self.contentView;
    
    m_post = [[MFMutablePost alloc] init];
    
    progressView.selectedIndex = 0;
    [self progressView:nil didSelectItemAtIndex:0];
    
    for(NSInteger i = 0, c = m_steps.count; i < c; i++) {
        MFNewPostController_Step *step = [m_steps objectAtIndex:i];
        MFNewPostPageView *page = [step.page createFreshView];
        
        step.page = page;
        [pages addObject:page];
    }
    
    contentView.selectedPage = 0;
    contentView.pages = pages;
    [self invalidateNavigation];
}

- (void)showPost:(MFPost *)post
{
    if(post && post.status == kMFPostStatusListed) {
        MFPostController *controller = [[MFPostController alloc] initWithPost:[[MFWebPost alloc] initWithPost:post] userInteractionEnabled:NO];
        
        //controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NewPost.Action.Close", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss:)];
        [m_hud hide:NO];
        m_hud = nil;
        [self clearPost];
        [self presentNavigableViewController:controller animated:YES completion:NULL];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NewPost.Alert.Posted.Title", nil)
                                                            message:NSLocalizedString(@"NewPost.Alert.Posted.Message", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"NewPost.Alert.Posted.Action.OK", nil)
                                                  otherButtonTitles:nil];
        
        alertView.tag = ALERT_GENERIC_CLEAR;
        
        [alertView show];
    }
}

- (void)requestPostStatus
{
    if(m_hud && m_post.identifier) {
        m_resubmitCounter += 1;
        
        if(m_resubmitCounter < 10) {
            m_hud.detailsLabelText = NSLocalizedString(@"NewPost.HUD.Posting.Message3", nil);
            
            [[MFWebService sharedService] requestPostDetails:m_post.identifier state:nil limit:100 target:self usingBlock:^(id target, NSError *error, MFPostDetails *details) {
                MFPost *post = details.post;
                
                if(post.status != kMFPostStatusListed) {
                    [self performSelector:@selector(requestPostStatus) withObject:nil afterDelay:1.0F];
                } else {
                    [self showPost:post];
                }
            }];
        } else {
            [self showPost:nil];
        }
    }
}

- (void)requestPost
{
    NSMutableArray *mediaIds = [[NSMutableArray alloc] init];
    
    for(NSString *imagePath in m_post.imagePaths) {
        MFNewPostController_Photo *photo = [m_photos objectForKey:imagePath];
        
        if(!photo) {
            photo = [[MFNewPostController_Photo alloc] init];
            [m_photos setObject:photo forKey:imagePath];
        }
        
        if(!photo.mediaId) {
            MFWebUpload *upload = [MFWebUpload sharedUpload];
            
            if(photo.ticket) {
                [upload clear:photo.ticket];
                m_post.identifier = nil;
            }
            
            m_hud.detailsLabelText = [NSString stringWithFormat:NSLocalizedString(@"NewPost.HUD.Posting.Message1", nil), (mediaIds.count + 1), m_post.imagePaths.count];
            photo.ticket = [upload addImageAtPath:imagePath];
            
            if(!photo.ticket) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NewPost.Alert.ImageError.Title", nil)
                                                                    message:NSLocalizedString(@"NewPost.Alert.ImageError.Message", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"NewPost.Alert.ImageError.Action.OK", nil)
                                                          otherButtonTitles:nil];
                
                alertView.tag = ALERT_GENERIC;
                
                [alertView show];
            }
            return;
        } else {
            [mediaIds addObject:photo.mediaId];
        }
    }
    
    
    if(!m_post.identifier) {
        m_resubmitCounter = 0;
        m_post.mediaIds = mediaIds;
        m_hud.detailsLabelText = NSLocalizedString(@"NewPost.HUD.Posting.Message2", nil);
        
        [[MFWebService sharedService] requestPostCreate:m_post target:self usingBlock:^(id target, NSError *error, MFPost *post) {
            if(error || !post) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NewPost.Alert.PostingError.Title", nil)
                                                                    message:NSLocalizedString(@"NewPost.Alert.PostingError.Message", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"NewPost.Alert.PostingError.Action.Close", nil)
                                                          otherButtonTitles:NSLocalizedString(@"NewPost.Alert.PostingError.Action.Retry", nil), nil];
                
                alertView.tag = ALERT_POSTING;
                [alertView show];
            } else {
                m_post.identifier = post.identifier;
                
                if(post.status == kMFPostStatusListed) {
                    [self showPost:post];
                } else if(post.status == kMFPostStatusUnlisted) {
                    [self requestPostStatus];
                } else {
                    [self showPost:nil];
                }
            }
        }];
    } else {
        [self requestPostStatus];
    }
}

- (IBAction)post:(id)sender
{
    
    if(!m_hud) {
        m_hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        m_hud.dimBackground = YES;
        m_hud.labelFont = [UIFont themeBoldFontOfSize:16.0F];
        m_hud.detailsLabelFont = [UIFont themeBoldFontOfSize:12.0F];
        m_hud.labelText = NSLocalizedString(@"NewPost.HUD.Posting.Title", nil);
        m_hud.detailsLabelText = @" ";
        m_hud.minShowTime = 1.0F;
        
        for(MFNewPostController_Step *step in m_steps) {
            [step.page saveState];
        }
        
        for(MFNewPostController_Step *step in m_steps) {
            [step.page submitting];
        }
        
        [self requestPost];
    }
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
        } else if([(MFNewPostController_Step *)[m_steps objectAtIndex:m_steps.count - 1] canContinue]) {
            [self post:nil];
        }
    }
}

- (void)invalidateNavigation
{
    NSInteger index = self.progressView.selectedIndex;
    
    if(index != NSNotFound && index < m_steps.count) {
        UIBarButtonItem *item = (UIBarButtonItem *)self.navigationItem.rightBarButtonItem;
        
        self.navigationItem.title = ((MFNewPostController_Step *)[m_steps objectAtIndex:index]).title;
        
        item.enabled = [(MFNewPostController_Step *)[m_steps objectAtIndex:index] canContinue];
        
        if(index + 1 >= m_steps.count) {
            item.title = NSLocalizedString(@"NewPost.Action.Done", nil);
            item.style = UIBarButtonItemStyleDone;
        } else {
            item.title = NSLocalizedString(@"NewPost.Action.Next", nil);
            item.style = UIBarButtonItemStylePlain;
        }
    }
}

- (MFNewPostController_Photo *)photoForTicket:(NSString *)ticket
{
    for(MFNewPostController_Photo *photo in m_photos.objectEnumerator) {
        if(MFEqual(photo.ticket, ticket)) {
            return photo;
        }
    }
    
    return nil;
}

- (void)uploadDidComplete:(NSNotification *)notification
{
    NSString *ticketId = [notification.userInfo objectForKey:MFWebUploadTicketKey];
    MFNewPostController_Photo *photo = [self photoForTicket:ticketId];
    
    if(photo) {
        NSString *mediaId = [notification.userInfo objectForKey:MFWebUploadIdentifierKey];
        
        photo.mediaId = mediaId;
        [self requestPost];
    }
}

- (void)uploadDidFail:(NSNotification *)notification
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NewPost.Alert.UploadingError.Title", nil)
                                                        message:NSLocalizedString(@"NewPost.Alert.UploadingError.Message", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"NewPost.Alert.UploadingError.Action.Close", nil)
                                              otherButtonTitles:NSLocalizedString(@"NewPost.Alert.UploadingError.Action.Retry", nil), nil];
    
    alertView.tag = ALERT_POSTING;
    [alertView show];
}

#pragma mark MFProgressViewDelegate

- (BOOL)progressView:(MFProgressView *)progressView shouldSelectItemAtIndex:(NSInteger)index
{
    NSInteger oldIndex = progressView.selectedIndex;
    
    if(oldIndex != NSNotFound && index > oldIndex) {
        for(NSInteger i = oldIndex, c = index; i < c; i++) {
            MFNewPostController_Step *step = [m_steps objectAtIndex:i];
            
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
        MFNewPostController_Step *step = [m_steps objectAtIndex:index];
        
        [contentView setSelectedPage:step.page animated:YES];
        [self invalidateNavigation];
    }
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch(alertView.tag) {
        case ALERT_POSTING:
            if(buttonIndex != alertView.cancelButtonIndex) {
                [self requestPost];
            } else {
                [m_hud hide:YES];
                m_hud = nil;
            }
            break;
        case ALERT_GENERIC:
            [m_hud hide:YES];
            m_hud = nil;
            break;
        case ALERT_GENERIC_CLEAR:
            [m_hud hide:YES];
            m_hud = nil;
            [self clearPost];
            break;
    }
}

#pragma mark UIView

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    MFProgressView *progressView = [[MFProgressView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFProgressView preferredHeight])];
    MFPageScrollView *contentView = [[MFPageScrollView alloc] initWithFrame:CGRectMake(0.0F, [MFProgressView preferredHeight], 320.0F, 480.0F - [MFProgressView preferredHeight])];
    NSMutableArray *items = [NSMutableArray array];
    NSMutableArray *pages = [NSMutableArray array];
    
    for(MFNewPostController_Step *step in m_steps) {
        [items addObject:step.label];
        [pages addObject:step.page];
    }
    
    [items addObject:NSLocalizedString(@"NewPost.Action.Done", nil)];
    
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
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        m_photos = [[NSMutableDictionary alloc] init];
        m_stepIndex = 0;
        m_steps = [[NSArray alloc] initWithObjects:
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Photos", nil), NSLocalizedString(@"NewPost.Title.Photos", nil), [self createPhotosPageView]),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.TypeSizeFit", nil), NSLocalizedString(@"NewPost.Title.TypeSizeFit", nil), [self createTypeSizeAndFitPageView]),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Condition", nil), NSLocalizedString(@"NewPost.Title.Condition", nil), [self createConditionPageView]),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Details", nil), NSLocalizedString(@"NewPost.Title.Details", nil), [self createDetailsPageView]),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Price", nil), NSLocalizedString(@"NewPost.Title.Price", nil), [self createPricePageView]),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.SellersNote", nil), NSLocalizedString(@"NewPost.Title.SellersNote", nil), [self createNotesPageView]), nil];
        m_post = [[MFMutablePost alloc] init];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NewPost.Action.Next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(next:)];
    
        [center addObserver:self selector:@selector(uploadDidComplete:) name:MFWebUploadDidCompleteNotification object:nil];
        [center addObserver:self selector:@selector(uploadDidFail:) name:MFWebUploadDidFailNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MFWebUpload sharedUpload] clear];
}

@end
