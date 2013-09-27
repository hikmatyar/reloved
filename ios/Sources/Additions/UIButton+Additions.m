/* Copyright (c) 2013 Meep Factory OU */

#import "UIButton+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation UIButton(Additions)

+ (UIButton *)themeButtonWithFrame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.backgroundColor = [UIColor themeButtonBackgroundColor];
    button.layer.borderWidth = 1.0F;
    button.layer.borderColor = [UIColor themeButtonBorderColor].CGColor;
    button.frame = frame;
    button.titleLabel.font = [UIFont themeFontOfSize:14.0F];
    [button setTitleColor:[UIColor themeButtonTextColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor themeButtonTextHighlightColor] forState:UIControlStateSelected];
    
    return button;
}

@end
