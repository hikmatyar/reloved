/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFPullToLoadMoreView, MFTableView, MFWebFeed;

@interface MFFeedController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    @private
    BOOL m_atEnd;
    BOOL m_autoRefresh;
    MFWebFeed *m_feed;
    NSArray *m_posts;
    BOOL m_updating;
    MFPullToLoadMoreView *m_pullToLoadMoreView;
}

- (id)initWithFeed:(MFWebFeed *)feed;

@property (nonatomic, retain) MFWebFeed *feed;
@property (nonatomic, retain, readonly) MFTableView *tableView;

- (void)feedDidChange;

@end