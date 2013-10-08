/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface UIColor(Additions)

+ (UIColor *)colorWithString:(NSString *)str;

+ (UIColor *)themeBackgroundColor;
+ (UIColor *)themeSeparatorColor;
+ (UIColor *)themeTextColor;
+ (UIColor *)themeTextAlternativeColor;

+ (UIColor *)themeButtonBackgroundColor;
+ (UIColor *)themeButtonBackgroundHighlightColor;
+ (UIColor *)themeButtonBorderColor;
+ (UIColor *)themeButtonBorderSelectedColor;
+ (UIColor *)themeButtonTextColor;
+ (UIColor *)themeButtonTextHighlightColor;
+ (UIColor *)themeButtonTextPlaceholderColor;

+ (UIColor *)themeInputBackgroundColor;
+ (UIColor *)themeInputTextColor;
+ (UIColor *)themeInputTextPlaceholderColor;

+ (UIColor *)themeSeparatorTopColor;
+ (UIColor *)themeSeparatorBottomColor;

+ (UIColor *)themeMenuBackgroundColor;
+ (UIColor *)themeMenuSeparatorColor;
+ (UIColor *)themeMenuTextColor;

@end
