/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFPullToLoadMoreView;

@protocol MFPullToLoadMoreViewDelegate <NSObject>

@optional

- (void)pullToLoadMoreAction:(MFPullToLoadMoreView *)pullToLoadView;

@end
