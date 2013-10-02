/* Copyright (c) 2013 Meep Factory OU */

#import "MFNewPostController.h"
#import "MFNewPostController+Condition.h"
#import "MFNewPostController+Details.h"
#import "MFNewPostController+Photos.h"
#import "MFNewPostController+Price.h"
#import "MFNewPostController+Notes.h"
#import "MFNewPostProgressView.h"
#import "MFPageView.h"
#import "MFPageScrollView.h"
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
    MFPageView *m_page;
}

- (id)initWithLabel:(NSString *)label title:(NSString *)title page:(MFPageView *)page;

@property (nonatomic, retain, readonly) NSString *label;
@property (nonatomic, retain, readonly) MFPageView *page;
@property (nonatomic, retain, readonly) NSString *title;

@end

@implementation MFNewPostController_Step

- (id)initWithLabel:(NSString *)label title:(NSString *)title page:(MFPageView *)page
{
    self = [super init];
    
    if(self) {
        m_label = label;
        m_title = title;
        m_page = (page) ? page : [[MFPageView alloc] initWithFrame:CGRectZero];
    }
    
    return self;
}

@synthesize label = m_label;
@synthesize page = m_page;
@synthesize title = m_title;

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

- (IBAction)menu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
}

- (IBAction)next:(id)sender
{
    MFNewPostProgressView *progressView = self.progressView;
    NSInteger index = progressView.selectedIndex;
    
    if(index + 1 < m_steps.count) {
        index += 1;
        
        if([self progressView:progressView shouldSelectItemAtIndex:index]) {
            progressView.selectedIndex = index;
            [self progressView:progressView didSelectItemAtIndex:index];
        }
    }
}

#pragma mark MFNewPostProgressViewDelegate

- (BOOL)progressView:(MFNewPostProgressView *)progressView shouldSelectItemAtIndex:(NSInteger)index
{
    MFNewPostController_Step *step = [m_steps objectAtIndex:index];
    
    return (step.title) ? YES : NO;
}

- (void)progressView:(MFNewPostProgressView *)progressView didSelectItemAtIndex:(NSInteger)index
{
    MFPageScrollView *contentView = self.contentView;
    MFNewPostController_Step *step = [m_steps objectAtIndex:index];
    
    [contentView setSelectedPage:step.page animated:YES];
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
    
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    progressView.delegate = self;
    progressView.items = items;
    progressView.selectedIndex = 0;
    progressView.tag = TAG_PROGRESS_VIEW;
    [view addSubview:progressView];
    
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.pages = pages;
    contentView.tag = TAG_CONTENT_VIEW;
    [view addSubview:contentView];
    
    view.backgroundColor = [UIColor themeBackgroundColor];
    
    self.view = view;
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        m_steps = [[NSArray alloc] initWithObjects:
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Photos", nil), NSLocalizedString(@"NewPost.Title.Photos", nil), [self createPhotosPageView]),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.TypeSizeFit", nil), NSLocalizedString(@"NewPost.Title.TypeSizeFit", [self createTypeSizeAndFitPageView]), nil),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Condition", nil), NSLocalizedString(@"NewPost.Title.Condition", nil), [self createConditionPageView]),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Details", nil), NSLocalizedString(@"NewPost.Title.Details", [self createDetailsPageView]), nil),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Price", nil), NSLocalizedString(@"NewPost.Title.Price", nil), [self createPricePageView]),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.SellersNote", nil), NSLocalizedString(@"NewPost.Title.SellersNote", [self createNotesPageView]), nil),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Done", nil), nil, nil), nil];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NewPost.Action.Next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(next:)];
    }
    
    return self;
}

@end
