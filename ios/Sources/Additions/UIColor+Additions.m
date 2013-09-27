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

+ (UIColor *)themeSeparatorColor
{
    return [self colorWithString:@"#d8d8d8"];
}

+ (UIColor *)themeTextColor
{
    return [self colorWithString:@"#000000"];
}

+ (UIColor *)themeMenuBackgroundColor
{
    return [self colorWithString:@"#dcdcdc"];
}

+ (UIColor *)themeMenuSeparatorColor
{
    return [self colorWithString:@"#dabfa3"];
}
// d8d8d8 + e4e4e4
+ (UIColor *)themeMenuTextColor
{
    return [self colorWithString:@"#000000"];
}

@end
