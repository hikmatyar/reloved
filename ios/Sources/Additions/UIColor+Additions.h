/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface UIColor(Additions)

+ (UIColor *)colorWithString:(NSString *)str;

+ (UIColor *)themeBackgroundColor;
+ (UIColor *)themeSeparatorColor;
+ (UIColor *)themeTextColor;
+ (UIColor *)themeTextAlternativeColor;
+ (UIColor *)themeTextBackgroundColor;

+ (UIColor *)themeBorderColor;
+ (UIColor *)themeButtonBackgroundColor;
+ (UIColor *)themeButtonBackgroundHighlightColor;
+ (UIColor *)themeButtonBorderColor;
+ (UIColor *)themeButtonBorderSelectedColor;
+ (UIColor *)themeButtonTextColor;
+ (UIColor *)themeButtonTextHighlightColor;
+ (UIColor *)themeButtonTextPlaceholderColor;

+ (UIColor *)themeImageBorderColor;

+ (UIColor *)themeInputBackgroundColor;
+ (UIColor *)themeInputTextColor;
+ (UIColor *)themeInputTextPlaceholderColor;

+ (UIColor *)themeProgressSeparatorColor;
+ (UIColor *)themeProgressTextColor;
+ (UIColor *)themeProgressTextSelectedColor;

+ (UIColor *)themeSeparatorTopColor;
+ (UIColor *)themeSeparatorBottomColor;

+ (UIColor *)themeMenuBackgroundColor;
+ (UIColor *)themeMenuSeparatorColor;
+ (UIColor *)themeMenuTextColor;

@end
