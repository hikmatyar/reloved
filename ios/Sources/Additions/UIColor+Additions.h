/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface UIColor(Additions)

+ (UIColor *)colorWithString:(NSString *)str;

+ (UIColor *)themeBackgroundColor;
+ (UIColor *)themeSeparatorColor;
+ (UIColor *)themeTextColor;

+ (UIColor *)themeMenuBackgroundColor;
+ (UIColor *)themeMenuSeparatorColor;
+ (UIColor *)themeMenuTextColor;

@end
