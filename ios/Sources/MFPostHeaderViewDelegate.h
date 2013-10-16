/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFPostHeaderView;

@protocol MFPostHeaderViewDelegate <NSObject>

@optional

- (void)headerView:(MFPostHeaderView *)headerView didSelectMedia:(NSString *)media;

@end
