/* Copyright (c) 2013 Meep Factory OU */

#import "MFNewPostController.h"
#import "MFNewPostProgressView.h"
#import "MFPageView.h"
#import "MFPageScrollView.h"
#import "MFSideMenuContainerViewController.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+MFSideMenuAdditions.h"

#define TAG_PROGRESS_VIEW 1000
#define TAG_CONTENT_VIEW 1001

#define STEP_ITEM(l, t) [[MFNewPostController_Step alloc] initWithLabel:l title:t]

@interface MFNewPostController_Step : NSObject
{
    @private
    NSString *m_label;
    NSString *m_title;
    MFPageView *m_page;
}

- (id)initWithLabel:(NSString *)label title:(NSString *)title;

@property (nonatomic, retain, readonly) NSString *label;
@property (nonatomic, retain, readonly) MFPageView *page;
@property (nonatomic, retain, readonly) NSString *title;

@end

@implementation MFNewPostController_Step

- (id)initWithLabel:(NSString *)label title:(NSString *)title
{
    self = [super init];
    
    if(self) {
        m_label = label;
        m_title = title;
        m_page = [[MFPageView alloc] initWithFrame:CGRectZero];
    }
    
    return self;
}

@synthesize label = m_label;
@synthesize page = m_page;
@synthesize title = m_title;

@end

#pragma mark -

@implementation MFNewPostController

- (UIScrollView *)contentView
{
    return (UIScrollView *)[self.view viewWithTag:TAG_CONTENT_VIEW];
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
    
}

#pragma mark MFNewPostProgressViewDelegate

- (BOOL)progressView:(MFNewPostProgressView *)progressView shouldSelectItemAtIndex:(NSInteger)index
{
    return YES;
}

- (void)progressView:(MFNewPostProgressView *)progressView didSelectItemAtIndex:(NSInteger)index
{
    UIScrollView *contentView = self.contentView;
    
    [contentView setContentOffset:CGPointMake(index * contentView.frame.size.width, 0.0F) animated:YES];
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
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Photos", nil), NSLocalizedString(@"NewPost.Title.Photos", nil)),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.TypeSizeFit", nil), NSLocalizedString(@"NewPost.Title.TypeSizeFit", nil)),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Condition", nil), NSLocalizedString(@"NewPost.Title.Condition", nil)),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Details", nil), NSLocalizedString(@"NewPost.Title.Details", nil)),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Price", nil), NSLocalizedString(@"NewPost.Title.Price", nil)),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.SellersNote", nil), NSLocalizedString(@"NewPost.Title.SellersNote", nil)),
            STEP_ITEM(NSLocalizedString(@"NewPost.Action.Done", nil), NSLocalizedString(@"", nil)), nil];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NewPost.Action.Next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(next:)];
    }
    
    return self;
}

@end
