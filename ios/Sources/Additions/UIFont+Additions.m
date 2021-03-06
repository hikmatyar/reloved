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

+ (UIFont *)themeLightFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+ (UIFont *)themeSmallFont
{
    return [self themeFontOfSize:13.0F];
}

+ (UIFont *)themeNormalFont
{
    return [self themeFontOfSize:24.0F];
}

@end
