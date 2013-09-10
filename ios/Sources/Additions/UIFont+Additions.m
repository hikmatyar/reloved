/* Copyright (c) 2013 Meep Factory OU */

#import "UIFont+Additions.h"

@implementation UIFont(Additions)

+ (UIFont *)themeFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (UIFont *)themeBoldFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

@end
