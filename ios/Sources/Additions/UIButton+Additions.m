/* Copyright (c) 2013 Meep Factory OU */

#import "UIButton+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIImage+Additions.h"

@implementation UIButton(Additions)

+ (UIButton *)themeButtonWithFrame:(CGRect)frame
{
    UIImage *backgroundImage = [UIImage imageWithColor:[UIColor themeButtonBackgroundHighlightColor]];
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    
    button.backgroundColor = [UIColor themeButtonBackgroundColor];
    button.layer.borderWidth = 1.0F;
    button.layer.borderColor = [UIColor themeButtonBorderColor].CGColor;
    button.frame = frame;
    button.titleLabel.font = [UIFont themeFontOfSize:12.0F];
    [button setTitleColor:[UIColor themeButtonTextColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor themeButtonTextHighlightColor] forState:UIControlStateSelected];
    [button setBackgroundImage:backgroundImage forState:UIControlStateSelected];
    [button setBackgroundImage:backgroundImage forState:UIControlStateHighlighted];
    
    return button;
}

@end
