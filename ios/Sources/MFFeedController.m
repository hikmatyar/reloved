/* Copyright (c) 2013 Meep Factory OU */

#import "MFFeed.h"
#import "MFFeedController.h"
#import "MFDatabase+Recents.h"
#import "MFDelta.h"
#import "MFPost.h"
#import "MFPostController.h"
#import "MFPostTableViewCell.h"
#import "MFPullToLoadMoreView.h"
#import "MFPullToLoadMoreViewDelegate.h"
#import "MFPullToRefreshView.h"
#import "MFPullToRefreshViewDelegate.h"
#import "MFTableView.h"
#import "MFWebFeed.h"
#import "MFWebPost.h"
#import "NSArray+Additions.h"
#import "NSDictionary+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define CELL_IDENTIFIER @"cell"

#define TAG_TABLEVIEW 2000
#define TAG_PULLTOREFRESH 2001

#define SECTION_POSTS 0
#define SECTION_MORE 1

@implementation MFFeedController

- (id)initWithFeed:(MFWebFeed *)feed
{
    self = [super init];
    
    if(self) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        if(feed && !feed.local) {
            m_pullToLoadMoreView = [[MFPullToLoadMoreView alloc] initWithFrame:CGRectMake(0.0F, 30.0F, 320.0F, 52.0F)];
            m_pullToLoadMoreView.delegate = (id <MFPullToLoadMoreViewDelegate>)self;
        }
        
        m_autoRefresh = YES;
        m_feed = feed;
        
        [center addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    
    return self;
}

@dynamic tableView;

- (MFTableView *)tableView
{
    return (MFTableView *)[self.view viewWithTag:TAG_TABLEVIEW];
}

- (MFPullToRefreshView *)pullToRefreshView
{
    return (MFPullToRefreshView *)[self.view viewWithTag:TAG_PULLTOREFRESH];
}

- (MFPullToLoadMoreView *)pullToLoadMoreView
{
    return m_pullToLoadMoreView;
}

@dynamic feed;

- (MFWebFeed *)feed
{
    return m_feed;
}

- (void)setFeed:(MFWebFeed *)feed
{
    if(m_feed != feed) {
        m_feed = feed;
        
        [self performSelector:@selector(feedDidChange:) withObject:nil];
        
        if(!m_feed.loadingForward) {
            [self.pullToRefreshView startLoading:NO];
            [m_feed loadForward];
        }
    }
}

- (void)addRecentPost:(MFPost *)post
{
    [[MFDatabase sharedDatabase] addRecentPost:post];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    m_autoRefresh = YES;
}

- (void)feedDidBeginLoading:(NSNotification *)notification
{
    if(m_feed.loadingForward) {
        [self.pullToRefreshView startLoading];
    }
    
    if(m_feed.loadingBackward) {
        [self.pullToLoadMoreView startLoading];
    }
}

- (void)feedDidEndLoading:(NSNotification *)notification
{
    if(m_feed == notification.object) {
        if(!m_feed.loadingForward) {
            [self.pullToRefreshView stopLoading];
        }
        
        if(!m_feed.loadingBackward) {
            [self.pullToLoadMoreView stopLoading];
            
            if(m_atEnd != m_feed.atEnd) {
                UITableView *tableView = self.tableView;
                
                m_atEnd = m_feed.atEnd;
                
                [tableView beginUpdates];
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_MORE] withRowAnimation:UITableViewRowAnimationFade];
                [tableView endUpdates];
            }
        }
    } else {
        if(self.pullToRefreshView.loading) {
            [m_feed loadForward];
        }
        
        if(self.pullToLoadMoreView.loading) {
            [m_feed loadBackward];
        }
    }
}

- (void)feedDidChange:(NSNotification *)notification
{
    if(!notification || m_feed == notification.object) {
        NSArray *changes = [notification.userInfo arrayForKey:MFWebFeedChangesKey];
        UITableView *tableView = self.tableView;
        BOOL atEnd = m_feed.atEnd;
        BOOL changeMore = (m_atEnd != atEnd) ? YES : NO;
        
        m_atEnd = atEnd;
        m_posts = m_feed.posts;
        
        if(changeMore) {
            m_pullToLoadMoreView.alpha = (m_atEnd) ? 0.0F : 1.0F;
            m_pullToLoadMoreView.hidden = (m_atEnd) ? YES : NO;
        }
        
        if(changes) {
            [tableView beginUpdates];
            
            for(MFDelta *change in changes) {
                switch(change.op) {
                    case kMFDeltaOpInsert:
                        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:change.index1 inSection:SECTION_POSTS]] withRowAnimation:UITableViewRowAnimationAutomatic];
                        break;
                    case kMFDeltaOpUpdate:
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:change.index1 inSection:SECTION_POSTS]] withRowAnimation:UITableViewRowAnimationAutomatic];
                        break;
                    case kMFDeltaOpMove:
                        [tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:change.index1 inSection:SECTION_POSTS] toIndexPath:[NSIndexPath indexPathForRow:change.index2 inSection:SECTION_POSTS]];
                        break;
                    case kMFDeltaOpDelete:
                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:change.index1 inSection:SECTION_POSTS]] withRowAnimation:UITableViewRowAnimationAutomatic];
                        break;
                    default:
                        break;
                }
            }
            
            if(changeMore) {
                NSMutableIndexSet *sections = [NSMutableIndexSet indexSet];
                
                if(changeMore) {
                    [sections addIndex:SECTION_MORE];
                }
                
                [tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
            }
            
            [tableView endUpdates];
        } else {
            [tableView reloadData];
        }
        
        [self feedDidChange];
    }
}

- (void)feedDidChange
{
}

#pragma mark MFPullToLoadMoreViewDelegate

- (void)pullToLoadMoreAction:(MFPullToLoadMoreView *)pullToLoadView
{
    [m_feed loadBackward];
}

#pragma mark MFPullToRefreshViewDelegate

- (void)pullToRefresh:(MFPullToRefreshView *)pullToRefreshView
{
    [m_feed loadForward];
}

- (void)pullToLoadMore:(MFPullToRefreshView *)pullToRefreshView
{
    if(!m_atEnd) {
        [m_feed loadBackward];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((section == SECTION_POSTS) ? m_posts.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFPost *post = [m_posts objectAtIndex:indexPath.row];
    MFPostTableViewCell *cell = (MFPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if(!cell) {
        cell = [[MFPostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.post = post;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFPost *post = [m_posts objectAtIndex:indexPath.row];
    MFPostController *controller = [[MFPostController alloc] initWithPost:[[MFWebPost alloc] initWithPost:post]];
    
    if(!m_feed.local) {
        [self addRecentPost:post];
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section == SECTION_MORE) ? ((m_atEnd || !m_pullToLoadMoreView) ? 0.0F : [MFPullToLoadMoreView preferredHeight]) : 0.0F;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return (section == SECTION_MORE) ? ((m_atEnd || !m_pullToLoadMoreView) ? [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 1.0F)] : m_pullToLoadMoreView) : nil;
}

#pragma mark UIViewController

- (void)loadView
{
    MFTableView *tableView = [[MFTableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) style:UITableViewStylePlain];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
    if(!m_feed.local) {
        MFPullToRefreshView *pullToRefreshView = [[MFPullToRefreshView alloc] initWithTableView:tableView];
        
        pullToRefreshView.delegate = (id <MFPullToRefreshViewDelegate>)self;
        pullToRefreshView.tag = TAG_PULLTOREFRESH;
        [tableView addSubview:pullToRefreshView];
    } else {
        tableView.delegate = self;
    }
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = [UIColor themeBackgroundColor];
    tableView.rowHeight = [MFPostTableViewCell preferredHeight];
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = 0.0F;
    tableView.tag = TAG_TABLEVIEW;
    
    [view addSubview:tableView];
    self.view = tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSArray *posts = m_feed.posts;
    UITableView *tableView = self.tableView;
    
    if(!MFEqual(m_posts, posts) || m_atEnd != m_feed.atEnd) {
        m_atEnd = m_feed.atEnd;
        m_posts = posts;
        m_pullToLoadMoreView.alpha = (m_atEnd) ? 0.0F : 1.0F;
        m_pullToLoadMoreView.hidden = (m_atEnd) ? YES : NO;
        [tableView reloadData];
    } else {
        NSIndexPath *selection = tableView.indexPathForSelectedRow;
        
        if(selection) {
            [tableView deselectRowAtIndexPath:selection animated:NO];
        }
    }
    
    [notificationCenter addObserver:self selector:@selector(feedDidBeginLoading:) name:MFWebFeedDidBeginLoadingNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(feedDidEndLoading:) name:MFWebFeedDidEndLoadingNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(feedDidChange:) name:MFWebFeedDidChangeNotification object:nil];
    
    [super viewWillAppear:animated];
    
    if(m_autoRefresh) {
        [m_feed loadForward];
        m_autoRefresh = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:MFWebFeedDidBeginLoadingNotification object:nil];
    [notificationCenter removeObserver:self name:MFWebFeedDidEndLoadingNotification object:nil];
    [notificationCenter removeObserver:self name:MFWebFeedDidChangeNotification object:nil];
    
    [super viewWillDisappear:animated];
}

#pragma mark NSObject

- (id)init
{
    return [self initWithFeed:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
