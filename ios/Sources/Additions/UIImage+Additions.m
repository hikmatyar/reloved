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

- (UIImage *)scaledImageWithMaxSize:(CGSize)maxSize quality:(CGFloat)quality
{
    CGSize oldSize = self.size;
    
    if(oldSize.width > maxSize.width || oldSize.height > maxSize.height) {
        CGFloat r1 = maxSize.width / oldSize.width;
        CGFloat r2 = maxSize.height / oldSize.height;
        CGFloat r = (r1 < r2) ? r1 : r2;
        CGRect newRect = CGRectIntegral(CGRectMake(0.0F, 0.0F, oldSize.width * r, oldSize.height * r));
        CGImageRef imageRef = self.CGImage, newImageRef;
        CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                    newRect.size.width,
                                                    newRect.size.height,
                                                    CGImageGetBitsPerComponent(imageRef),
                                                    0,
                                                    CGImageGetColorSpace(imageRef),
                                                    CGImageGetBitmapInfo(imageRef));
        UIImage *newImage;
        
        CGContextSetInterpolationQuality(bitmap, quality);
        CGContextDrawImage(bitmap, newRect, imageRef);
        
        newImageRef = CGBitmapContextCreateImage(bitmap);
        newImage = [UIImage imageWithCGImage:newImageRef];
        
        CGContextRelease(bitmap);
        CGImageRelease(newImageRef);
        
        return newImage;
    }
    
    return self;
}

@end