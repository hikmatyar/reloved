/* Copyright (c) 2013 Meep Factory OU */

#import "UIColor+Additions.h"

@implementation UIColor(Additions)

+ (UIColor *)colorWithString:(NSString *)str
{
    unsigned char red = 0, green = 0, blue = 0, alpha = 255;
    const char *chars = str.UTF8String;
    size_t length;
    
    if(chars != NULL && chars[0] == '#' && (length = strlen(chars)) == 7) {
        char *end;
        long int data = strtol(chars + 1, &end, 16);
        
        if(chars + length == end) {
            red = (data >> 16) & 0xFF;
            green = (data >> 8) & 0xFF;
            blue = (data >> 0) & 0xFF;
        }
    }
    
    return [self colorWithRed:(float)red / 255.0F green:(float)green / 255.0F blue:(float)blue / 255.0F alpha:(float)alpha / 255.0F];
}

+ (UIColor *)themeBackgroundColor
{
    return [self colorWithString:@"#eeeeee"];
}

+ (UIColor *)themeBackgroundHighlightColor
{
    return [self colorWithString:@"#f5f5f5"];
}

+ (UIColor *)themeSeparatorColor
{
    return [self colorWithString:@"#d8d8d8"];
}

+ (UIColor *)themeTextColor
{
    return [self colorWithString:@"#000000"];
}

+ (UIColor *)themeTextAlternativeColor
{
    return [self colorWithString:@"#666666"];
}

+ (UIColor *)themeTextBackgroundColor
{
    return [self colorWithString:@"#ffffff"];
}

+ (UIColor *)themeTextDisabledColor
{
    return [self colorWithString:@"#999999"];
}

+ (UIColor *)themeBorderColor
{
    return [self colorWithString:@"#ffffff"];
}

+ (UIColor *)themeButtonActionColor
{
    return [self colorWithString:@"#336699"];
}

+ (UIColor *)themeButtonActionHighlightColor
{
    return [self colorWithString:@"#4477aa"];
}

+ (UIColor *)themeButtonBackgroundColor
{
    return [self colorWithString:@"#ffffff"];
}

+ (UIColor *)themeButtonBackgroundHighlightColor
{
    return [self colorWithString:@"#f5f5f5"];
}

+ (UIColor *)themeButtonBorderColor
{
    return [self themeSeparatorColor];
}

+ (UIColor *)themeButtonBorderSelectedColor
{
    return [self colorWithString:@"#996633"];
}

+ (UIColor *)themeButtonTextColor
{
    return [self colorWithString:@"#000000"];
}

+ (UIColor *)themeButtonTextHighlightColor
{
    return [self colorWithString:@"#111111"];
}

+ (UIColor *)themeButtonTextPlaceholderColor
{
    return [self themeInputTextPlaceholderColor];
}

+ (UIColor *)themeImageBorderColor
{
    return [self colorWithString:@"#e4e4e4"];
}

+ (UIColor *)themeInputBackgroundColor
{
    return [self colorWithString:@"#ffffff"];
}

+ (UIColor *)themeInputTextColor
{
    return [self colorWithString:@"#000000"];
}

+ (UIColor *)themeInputTextPlaceholderColor
{
    return [self colorWithString:@"#999999"];
}

+ (UIColor *)themeProgressSeparatorColor
{
    return [self colorWithString:@"#f3c78b"];
}

+ (UIColor *)themeProgressTextColor
{
    return [self colorWithString:@"#7677a7"];
}

+ (UIColor *)themeProgressTextSelectedColor
{
    return [self colorWithString:@"#000000"];
}

+ (UIColor *)themeSeparatorTopColor
{
    return [self colorWithString:@"#d8d8d8"];
}

+ (UIColor *)themeSeparatorBottomColor
{
    return [self colorWithString:@"#e4e4e4"];
}

+ (UIColor *)themeMenuBackgroundColor
{
    return [self colorWithString:@"#dcdcdc"];
}

+ (UIColor *)themeMenuBackgroundHighlightColor
{
    return [self colorWithString:@"#ececec"];
}

+ (UIColor *)themeMenuSeparatorColor
{
    return [self colorWithString:@"#dabfa3"];
}

+ (UIColor *)themeMenuTextColor
{
    return [self colorWithString:@"#000000"];
}

+ (UIColor *)themeSectionIndexBackgroundColor
{
    return nil;
}

+ (UIColor *)themeSectionIndexColor
{
    return nil;
}

+ (UIColor *)themeSectionIndexTrackingBackgroundColor
{
    return nil;
}

@end
