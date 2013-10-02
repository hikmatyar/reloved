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
