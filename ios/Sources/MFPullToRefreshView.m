/* Copyright (c) 2013 Meep Factory OU */

#import <QuartzCore/QuartzCore.h>
#import "MFPullToRefreshView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define REFRESH_HEADER_HEIGHT 52.0F

@interface MFPullToRefreshView(Private)

@property (nonatomic, assign, readonly) UITableView *tableView;

- (void)stopLoadingComplete;

@end

@implementation MFPullToRefreshView

+ (CGFloat)preferredHeight
{
    return REFRESH_HEADER_HEIGHT;
}

- (UITableView *)tableView
{
    UIView *superview = self.superview;
    Class klass = [UITableView class];
    
    return ([superview isMemberOfClass:klass] || [superview isKindOfClass:klass]) ? (UITableView *)superview : nil;
}

- (id)initWithTableView:(UITableView *)tableView
{
    self = [self initWithFrame:CGRectMake(0.0F, 0.0F - REFRESH_HEADER_HEIGHT, tableView.frame.size.width, REFRESH_HEADER_HEIGHT)];
    
    if(self) {
        tableView.delegate = self;
    }
    
    return self;
}

@synthesize delegate = m_delegate;
@synthesize loading = m_loading;

- (void)startLoading
{
    [self startLoading:YES];
}

- (void)startLoading:(BOOL)animated
{
    if(!m_loading) {
        m_loading = YES;
        m_loadingTime = [NSDate timeIntervalSinceReferenceDate];
        
        if(animated) {
            [UIView animateWithDuration:0.3F animations:^{
                self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0.0F, 0.0F, 0.0F);
                m_refreshLabel.text = NSLocalizedString(@"PullToRefresh.Label.Loading", nil);
                m_refreshArrow.hidden = YES;
                [m_refreshSpinner startAnimating];
            }];
        } else {
            m_refreshLabel.text = NSLocalizedString(@"PullToRefresh.Label.Loading", nil);
            m_refreshArrow.hidden = YES;
            [m_refreshSpinner startAnimating];
        }
        
        if([m_delegate respondsToSelector:@selector(pullToRefresh:)]) {
            [m_delegate pullToRefresh:self];
        } else {
            [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0F];
        }
    }
}

- (void)stopLoading
{
    if(m_loading) {
        NSTimeInterval delay = 0.35F - fabs([NSDate timeIntervalSinceReferenceDate] - m_loadingTime);
        
        m_loading = NO;
        
        [UIView animateWithDuration:0.3F delay:(delay > 0.0F) ? delay : 0.0F options:0 animations:^{
            self.tableView.contentInset = UIEdgeInsetsZero;
            m_refreshArrow.layer.transform = CATransform3DMakeRotation(M_PI * 2.0F, 0.0F, 0.0F, 1.0F);
        } completion:^(BOOL finished) {
            [self performSelector:@selector(stopLoadingComplete)];
        }];
    }
}

- (void)stopLoadingComplete
{
    m_refreshLabel.text = NSLocalizedString(@"PullToRefresh.Label.Pull", nil);
    m_refreshArrow.hidden = NO;
    [m_refreshSpinner stopAnimating];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(!m_loading) {
        m_dragging = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(m_loading) {
        if(scrollView.contentOffset.y > 0.0F) {
            self.tableView.contentInset = UIEdgeInsetsZero;
        } else if(scrollView.contentOffset.y >= 0.0F - self.frame.size.height) {
           self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0.0F, 0.0F, 0.0F);
        }
    } else if(m_dragging && scrollView.contentOffset.y < 0.0F) {
        [UIView animateWithDuration:0.25F animations:^{
            if(scrollView.contentOffset.y < 0.0F - self.frame.size.height) {
                m_refreshLabel.text = NSLocalizedString(@"PullToRefresh.Label.Release", nil);
                m_refreshArrow.layer.transform = CATransform3DMakeRotation(M_PI, 0.0F, 0.0F, 1.0F);
            } else {
                m_refreshLabel.text = NSLocalizedString(@"PullToRefresh.Label.Pull", nil);
                m_refreshArrow.layer.transform = CATransform3DMakeRotation(M_PI * 2.0F, 0.0F, 0.0F, 1.0F);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!m_loading) {
        UITableView *tableView = self.tableView;
        
        m_dragging = NO;
        
        if(scrollView.contentOffset.y <= 0.0F - self.frame.size.height) {
            [self startLoading];
        } else if(scrollView.contentOffset.y >= ((CGRectGetMaxY([tableView rectForSection:tableView.numberOfSections - 1]) < scrollView.frame.size.height) ? 0.0F : scrollView.contentSize.height - scrollView.frame.size.height) + self.frame.size.height) {
            if([m_delegate respondsToSelector:@selector(pullToLoadMore:)]) {
                [m_delegate pullToLoadMore:self];
            }
        }
    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if([m_delegate respondsToSelector:@selector(tableView: accessoryButtonTappedForRowWithIndexPath:)]) {
        [m_delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([m_delegate respondsToSelector:@selector(tableView: didSelectRowAtIndexPath:)]) {
        [m_delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([m_delegate respondsToSelector:@selector(tableView: heightForRowAtIndexPath:)]) ? [m_delegate tableView:tableView heightForRowAtIndexPath:indexPath] : tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ([m_delegate respondsToSelector:@selector(tableView: heightForFooterInSection:)]) ? [m_delegate tableView:tableView heightForFooterInSection:section] : 0.0F;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return ([m_delegate respondsToSelector:@selector(tableView: viewForFooterInSection:)]) ? [m_delegate tableView:tableView viewForFooterInSection:section] : nil;
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        m_refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, 0.0F, frame.size.width, frame.size.height)];
        m_refreshLabel.backgroundColor = [UIColor clearColor];
        m_refreshLabel.font = [UIFont themeBoldFontOfSize:12.0F];
        m_refreshLabel.textAlignment = NSTextAlignmentCenter;
        m_refreshLabel.textColor = [UIColor themeTextColor];
        
        m_refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PullToRefresh-Arrow.png"]];
        m_refreshArrow.frame = CGRectMake(floorf((frame.size.height - 27.0F) / 2.0F), (floorf(frame.size.height - 44.0F) / 2.0F), 27.0F, 44.0F);
        
        m_refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        m_refreshSpinner.frame = CGRectMake(floorf(floorf(frame.size.height - 20.0F) / 2.0F), floorf((frame.size.height - 20.0F) / 2.0F), 20.0F, 20.0F);
        m_refreshSpinner.hidesWhenStopped = YES;
        
        [self addSubview:m_refreshLabel];
        [self addSubview:m_refreshArrow];
        [self addSubview:m_refreshSpinner];
    }
    
    return self;
}

@end
