/* Copyright (c) 2013 Meep Factory OU */

#import "MFSeparatorView.h"
#import "UIColor+Additions.h"

@implementation MFSeparatorView

- (id)initWithPosition:(CGFloat)position
{
    return [self initWithFrame:CGRectMake(0.0F, position - 1.0F, 320.0F, 2.0F)];
}

@dynamic topColor;

- (UIColor *)topColor
{
    return self.backgroundColor;
}

- (void)setTopColor:(UIColor *)topColor
{
    self.backgroundColor = topColor;
}

@dynamic bottomColor;

- (UIColor *)bottomColor
{
    return m_bottomView.backgroundColor;
}

- (void)setBottomColor:(UIColor *)bottomColor
{
    m_bottomView.backgroundColor = bottomColor;
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        m_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, frame.size.height - 1.0F, frame.size.width, 1.0F)];
        m_bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:m_bottomView];
        
        self.backgroundColor = [UIColor themeSeparatorTopColor];
        m_bottomView.backgroundColor = [UIColor themeSeparatorBottomColor];
    }
    
    return self;
}

@end
