/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface UIColor(Additions)

+ (UIColor *)colorWithString:(NSString *)str;

+ (UIColor *)themeBackgroundColor;
+ (UIColor *)themeSeparatorColor;
+ (UIColor *)themeTextColor;

+ (UIColor *)themeButtonBackgroundColor;
+ (UIColor *)themeButtonBackgroundHighlightColor;
+ (UIColor *)themeButtonBorderColor;
+ (UIColor *)themeButtonTextColor;
+ (UIColor *)themeButtonTextHighlightColor;

+ (UIColor *)themeSeparatorTopColor;
+ (UIColor *)themeSeparatorBottomColor;

+ (UIColor *)themeMenuBackgroundColor;
+ (UIColor *)themeMenuSeparatorColor;
+ (UIColor *)themeMenuTextColor;

@end
