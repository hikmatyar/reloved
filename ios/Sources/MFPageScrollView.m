/* Copyright (c) 2013 Meep Factory OU */

#import "MFPageView.h"
#import "MFPageScrollView.h"

@implementation MFPageScrollView

@dynamic pages;

- (NSArray *)pages
{
    NSMutableArray *pages = [NSMutableArray array];
    
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[MFPageView class]]) {
            [pages addObject:view];
        }
    }
    
    return pages;
}

- (void)setPages:(NSArray *)pages
{
    CGRect frame = self.bounds;
    
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[MFPageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if(pages.count > 0) {
        CGRect pageRect = CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height);
        
        for(MFPageView *page in pages) {
            page.frame = pageRect;
            [self addSubview:page];
            pageRect.origin.x += pageRect.size.width;
        }
        
        self.contentSize = CGSizeMake(frame.size.width * pages.count, frame.size.height);
    } else {
        self.contentSize = CGSizeZero;
    }
}

@dynamic selectedPage;

- (MFPageView *)selectedPage
{
    NSInteger index = roundf(self.contentOffset.x / self.bounds.size.width);
    
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[MFPageView class]]) {
            if(index == 0) {
                return (MFPageView *)view;
            }
            
            index--;
        }
    }
    
    return nil;
}

- (void)setSelectedPage:(MFPageView *)selectedPage
{
    [self setSelectedPage:selectedPage animated:NO];
}

- (void)setSelectedPage:(MFPageView *)selectedPage animated:(BOOL)animated
{
    if(selectedPage.superview == self) {
        MFPageView *selectedPage_ = self.selectedPage;
        
        if(selectedPage_ != selectedPage) {
            [selectedPage_ pageWillDisappear];
            [selectedPage pageWillAppear];
            [self setContentOffset:CGPointMake(selectedPage.frame.origin.x, 0.0F) animated:animated];
            [selectedPage_ pageDidDisappear];
            [selectedPage pageDidAppear];
        }
    }
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.scrollEnabled = NO;
    }
    
    return self;
}

- (void)layoutSubviews
{
    CGRect frame = self.bounds;
    CGSize contentSize = CGSizeMake(0.0F, frame.size.height);
    CGRect pageRect = CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height);
    
    [super layoutSubviews];
    
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[MFPageView class]]) {
            view.frame = pageRect;
            pageRect.origin.x += pageRect.size.width;
        }
    }
    
    if(!CGSizeEqualToSize(self.contentSize, contentSize)) {
        self.contentSize = contentSize;
    }
}

@end
