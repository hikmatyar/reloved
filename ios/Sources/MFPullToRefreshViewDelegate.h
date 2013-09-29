/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFPullToRefreshView;

@protocol MFPullToRefreshViewDelegate <UITableViewDelegate>

@optional

- (void)pullToRefresh:(MFPullToRefreshView *)pullToRefreshView;
- (void)pullToLoadMore:(MFPullToRefreshView *)pullToRefreshView;

@end