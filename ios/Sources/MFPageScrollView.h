/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFPageView;

@interface MFPageScrollView : UIScrollView

@property (nonatomic, retain) NSArray *pages;
@property (nonatomic, retain) MFPageView *selectedPage;
- (void)setSelectedPage:(MFPageView *)selectedPage animated:(BOOL)animated;

@end
