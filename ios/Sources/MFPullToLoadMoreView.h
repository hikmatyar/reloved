/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@protocol MFPullToLoadMoreViewDelegate;

@interface MFPullToLoadMoreView : UIView
{
    @private
    UIActivityIndicatorView *m_activityIndicatorView;
    __unsafe_unretained id <MFPullToLoadMoreViewDelegate> m_delegate;
    BOOL m_loading;
    UILabel *m_textLabel;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, assign) id <MFPullToLoadMoreViewDelegate> delegate;
@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;

- (void)startLoading;
- (void)stopLoading;

@end
