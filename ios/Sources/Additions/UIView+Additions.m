/* Copyright (c) 2013 Meep Factory OU */

#import "UIView+Additions.h"
#import "UIColor+Additions.h"

@implementation UIView(Additions)

+ (UIView *)themeSeparatorView
{
    UIView *view = [[self alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 1.0F)];
            
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    view.backgroundColor = [UIColor themeSeparatorColor];
    
    return view;
}

@end
