/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFHomeHeaderView;

@protocol MFHomeHeaderViewDelegate <NSObject>

@required

- (void)headerViewDidSelectShopByColor:(MFHomeHeaderView *)headerView;
- (void)headerViewDidSelectShopByDress:(MFHomeHeaderView *)headerView;
- (void)headerViewDidSelectShopByFeatured:(MFHomeHeaderView *)headerView;

@end
