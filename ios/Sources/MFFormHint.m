/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormHint.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFFormHint

+ (CGFloat)preferredHeight
{
    return 30.0F;
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        UIEdgeInsets edgeInsets = self.edgeInsets;
        
        self.edgeInsets = UIEdgeInsetsMake(3.0F, edgeInsets.left, edgeInsets.bottom, edgeInsets.right);
        self.font = [UIFont themeFontOfSize:14.0F];
        self.textColor = [UIColor themeTextAlternativeColor];
    }
    
    return self;
}

@end
