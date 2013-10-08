/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormFooter.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFFormFooter

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
        m_edgeInsets = UIEdgeInsetsMake(2.0F, 5.0F, 2.0F, 5.0F);
        
        self.font = [UIFont themeFontOfSize:16.0F];
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor themeTextColor];
    }
    
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, m_edgeInsets)];
}

@end
