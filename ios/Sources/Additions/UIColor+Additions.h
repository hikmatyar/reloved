/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface UIColor(Additions)

+ (UIColor *)colorWithString:(NSString *)str;

+ (UIColor *)themeBackgroundColor;
+ (UIColor *)themeBackgroundHighlightColor;
+ (UIColor *)themeFeedBackgroundColor;
+ (UIColor *)themeFeedBackgroundHighlightColor;
+ (UIColor *)themeSeparatorColor;
+ (UIColor *)themeTextColor;
+ (UIColor *)themeTextAlternativeColor;
+ (UIColor *)themeTextBackgroundColor;
+ (UIColor *)themeTextDisabledColor;
+ (UIColor *)themeTextErrorColor;

+ (UIColor *)themeBorderColor;
+ (UIColor *)themeButtonActionColor;
+ (UIColor *)themeButtonActionHighlightColor;
+ (UIColor *)themeButtonAltTextColor;
+ (UIColor *)themeButtonAltBackgroundColor;
+ (UIColor *)themeButtonAltBackgroundHighlightColor;
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
+ (UIColor *)themeMenuBackgroundHighlightColor;
+ (UIColor *)themeMenuSeparatorColor;
+ (UIColor *)themeMenuTextColor;

+ (UIColor *)themeSectionIndexBackgroundColor;
+ (UIColor *)themeSectionIndexColor;
+ (UIColor *)themeSectionIndexTrackingBackgroundColor;

@end
