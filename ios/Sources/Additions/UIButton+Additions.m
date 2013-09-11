/* Copyright (c) 2013 Meep Factory OU */

#import "UIButton+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation UIButton(Additions)

+ (UIButton *)themeButtonWithFrame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.backgroundColor = [UIColor grayColor];
    button.frame = frame;
    button.titleLabel.font = [UIFont themeFontOfSize:14.0F];
    
    return button;
}

@end
