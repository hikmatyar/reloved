/* Copyright (c) 2013 Meep Factory OU */

#import "MFPullToLoadMoreView.h"
#import "MFPullToLoadMoreViewDelegate.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFPullToLoadMoreView

@synthesize delegate = m_delegate;
@synthesize loading = m_loading;

- (void)startLoading
{
    if(!m_loading) {
        m_loading = YES;
        m_textLabel.text = NSLocalizedString(@"PullToLoadMore.Label.Loading", nil);
        [m_activityIndicatorView startAnimating];
    }
}

- (void)stopLoading
{
    if(m_loading) {
        [m_activityIndicatorView stopAnimating];
        m_textLabel.text = NSLocalizedString(@"PullToLoadMore.Label.Pull", nil);
        m_loading = NO;
    }
}

- (IBAction)action:(id)sender
{
    if(!m_loading && [m_delegate respondsToSelector:@selector(pullToLoadMoreAction:)]) {
        [m_delegate pullToLoadMoreAction:self];
    }
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        m_textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0F, round(frame.size.height * 0.5F) - 10.0F, frame.size.width, 20.0F)];
        m_textLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        m_textLabel.font = [UIFont themeBoldFontOfSize:12.0F];
        m_textLabel.backgroundColor = [UIColor clearColor];
        m_textLabel.text = NSLocalizedString(@"PullToLoadMore.Label.Pull", nil);
        m_textLabel.textAlignment = NSTextAlignmentCenter;
        m_textLabel.textColor = [UIColor themeTextAlternativeColor];
        [self addSubview:m_textLabel];
        
        m_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        m_activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        m_activityIndicatorView.frame = CGRectMake(floorf(floorf(frame.size.height - 20.0F) / 2.0F), floorf((frame.size.height - 20.0F) / 2.0F), 20.0F, 20.0F);
        m_activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:m_activityIndicatorView];
        
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        button.frame = CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height);
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}

@end
