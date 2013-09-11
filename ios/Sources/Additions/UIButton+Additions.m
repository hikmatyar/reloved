/* Copyright (c) 2013 Meep Factory OU */

#import "UIButton+Additions.h"

@implementation UIButton(Additions)

+ (UIButton *)themeButtonWithFrame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.backgroundColor = [UIColor grayColor];
    button.frame = frame;
    
    return button;
}

@end
