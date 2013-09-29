/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@protocol MFPullToRefreshViewDelegate;

@interface MFPullToRefreshView : UIView <UIScrollViewDelegate, UITableViewDelegate>
{
    @private
    __unsafe_unretained id <MFPullToRefreshViewDelegate> m_delegate;
    BOOL m_dragging;
    BOOL m_loading;
    NSTimeInterval m_loadingTime;
    UIImageView *m_refreshArrow;
    UIView *m_refreshHeaderView;
    UILabel *m_refreshLabel;
    UIActivityIndicatorView *m_refreshSpinner;
}

+ (CGFloat)preferredHeight;

- (id)initWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) id <MFPullToRefreshViewDelegate> delegate;
@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;

- (void)startLoading;
- (void)startLoading:(BOOL)animated;
- (void)stopLoading;

@end
