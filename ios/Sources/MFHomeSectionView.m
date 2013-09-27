/* Copyright (c) 2013 Meep Factory OU */

#import "MFHomeSectionView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFHomeSectionView

+ (CGFloat)preferredHeight
{
    return 34.0F;
}

- (id)initWithTitle:(NSString *)title
{
    self = [self initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [self.class preferredHeight])];
    
    if(self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.title = title;
    }
    
    return self;
}

@dynamic title;

- (NSString *)title
{
    return m_titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
    m_titleLabel.text = title;
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, 1.0F)];
        UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, frame.size.height - 1.0F, frame.size.width, 1.0F)];
        
        self.backgroundColor = [UIColor themeBackgroundColor];
        
        topSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        topSeparatorView.backgroundColor = [UIColor themeSeparatorBottomColor];
        [self addSubview:topSeparatorView];
        
        bottomSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        bottomSeparatorView.backgroundColor = [UIColor themeSeparatorTopColor];
        [self addSubview:bottomSeparatorView];
        
        m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0F, 6.0F, frame.size.width - 20.0F, 26.0F)];
        m_titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        m_titleLabel.backgroundColor = [UIColor clearColor];
        m_titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_titleLabel.numberOfLines = 0.0F;
        m_titleLabel.textColor = [UIColor themeTextColor];
        m_titleLabel.font = [UIFont themeBoldFontOfSize:15.0F];
        [self addSubview:m_titleLabel];
    }
    
    return self;
}

@end
