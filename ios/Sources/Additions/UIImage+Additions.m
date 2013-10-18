/* Copyright (c) 2013 Meep Factory OU */

#import "UIImage+Additions.h"

@implementation UIImage(Additions)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0F, 0.0F, 1.0F, 1.0F);
    CGContextRef ctx;
    UIImage *image;
    
    UIGraphicsBeginImageContext(rect.size);
    ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, rect);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end