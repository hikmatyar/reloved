/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormLabel.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFFormLabel

+ (CGFloat)preferredHeight
{
    return 50.0F;
}

@synthesize edgeInsets = m_edgeInsets;

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, frame.size.height - 1.0F, frame.size.width, 1.0F)];
        
        m_edgeInsets = UIEdgeInsetsMake(20.0F, 17.0F, 2.0F, 0.0F);
        
        self.font = [UIFont themeBoldFontOfSize:16.0F];
        self.textAlignment = NSTextAlignmentLeft;
        self.textColor = [UIColor themeTextColor];
        
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        separatorView.backgroundColor = [UIColor themeSeparatorBottomColor];
        [self addSubview:separatorView];
    }
    
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, m_edgeInsets)];
}

@end
