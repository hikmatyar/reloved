/* Copyright (c) 2013 Meep Factory OU */

#import "MFNewPostController.h"
#import "MFNewPostController+Condition.h"
#import "MFNewPostController+Details.h"
#import "MFNewPostController+Photos.h"
#import "MFNewPostController+Price.h"
#import "MFNewPostController+Notes.h"
#import "MFNewPostController+TypeSizeAndFit.h"
#import "MFNewPostPageView.h"
#import "MFNewPostProgressView.h"
#import "MFPageScrollView.h"
#import "MFPost.h"
#import "MFSideMenuContainerViewController.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+MFSideMenuAdditions.h"

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
@property (nonatomic, retain, readonly) MFNewPostPageView *page;
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

@implementation MFNewPostController

- (MFPageScrollView *)contentView
{
    return (MFPageScrollView *)[self.view viewWithTag:TAG_CONTENT_VIEW];
}

- (MFNewPostProgressView *)progressView
{
    return (MFNewPostProgressView *)[self.view viewWithTag:TAG_PROGRESS_VIEW];
}

@synthesize post = m_post;

- (IBAction)menu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
}

- (IBAction)post:(id)sender
{
    for(MFNewPostController_Step *step in m_steps) {
        [step.page submitting];
    }
    
    
}

- (IBAction)next:(id)sender
{
    MFNewPostProgressView *progressView = self.progressView;
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
        
        if(index + 1 >= m_steps.count) {
            item.title = NSLocalizedString(@"NewPost.Action.Done", nil);
            item.enabled = YES;
            item.style = UIBarButtonItemStyleDone;
        } else {
            item.title = NSLocalizedString(@"NewPost.Action.Next", nil);
            item.enabled = [(MFNewPostController_Step *)[m_steps objectAtIndex:index] canContinue];
            item.style = UIBarButtonItemStylePlain;
        }
    }
}

#pragma mark MFNewPostProgressViewDelegate

- (BOOL)progressView:(MFNewPostProgressView *)progressView shouldSelectItemAtIndex:(NSInteger)index
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

- (void)progressView:(MFNewPostProgressView *)progressView didSelectItemAtIndex:(NSInteger)index
{
    if(index >= 0 && index < m_steps.count) {
        MFPageScrollView *contentView = self.contentView;
        MFNewPostController_Step *step = [m_steps objectAtIndex:index];
        
        [contentView setSelectedPage:step.page animated:YES];
        [self invalidateNavigation];
    }
}

#pragma mark UIView

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    MFNewPostProgressView *progressView = [[MFNewPostProgressView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFNewPostProgressView preferredHeight])];
    MFPageScrollView *contentView = [[MFPageScrollView alloc] initWithFrame:CGRectMake(0.0F, [MFNewPostProgressView preferredHeight], 320.0F, 480.0F - [MFNewPostProgressView preferredHeight])];
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
    }
    
    return self;
}

@end
