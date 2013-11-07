/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface UIImage(Additions)

+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *)scaledImageWithMaxSize:(CGSize)maxSize quality:(CGFloat)quality;

@end
