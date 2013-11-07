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
        CGRect transposedRect = CGRectMake(0.0F, 0.0F, newRect.size.height, newRect.size.width);
        CGImageRef imageRef = self.CGImage, newImageRef;
        CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                    newRect.size.width,
                                                    newRect.size.height,
                                                    CGImageGetBitsPerComponent(imageRef),
                                                    0,
                                                    CGImageGetColorSpace(imageRef),
                                                    CGImageGetBitmapInfo(imageRef));
        CGAffineTransform transform = CGAffineTransformIdentity;
        UIImageOrientation orientation = self.imageOrientation;
        UIImage *newImage;
        BOOL transpose;
        
        switch(orientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                transpose = YES;
                break;
            default:
                transpose = NO;
        }
        
        switch(orientation) {
            case UIImageOrientationDown:           // EXIF = 3
            case UIImageOrientationDownMirrored:   // EXIF = 4
                transform = CGAffineTransformTranslate(transform, newRect.size.width, newRect.size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
            case UIImageOrientationLeft:           // EXIF = 6
            case UIImageOrientationLeftMirrored:   // EXIF = 5
                transform = CGAffineTransformTranslate(transform, newRect.size.width, 0.0F);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
            case UIImageOrientationRight:          // EXIF = 8
            case UIImageOrientationRightMirrored:  // EXIF = 7
                transform = CGAffineTransformTranslate(transform, 0.0F, newRect.size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
            default:
                break;
        }
        
        switch(orientation) {
            case UIImageOrientationUpMirrored:     // EXIF = 2
            case UIImageOrientationDownMirrored:   // EXIF = 4
                transform = CGAffineTransformTranslate(transform, newRect.size.width, 0.0F);
                transform = CGAffineTransformScale(transform, -1.0F, 1.0F);
                break;
            case UIImageOrientationLeftMirrored:   // EXIF = 5
            case UIImageOrientationRightMirrored:  // EXIF = 7
                transform = CGAffineTransformTranslate(transform, newRect.size.height, 0.0F);
                transform = CGAffineTransformScale(transform, -1.0F, 1.0F);
                break;
            default:
                break;
        }
        
        CGContextSetInterpolationQuality(bitmap, quality);
        CGContextConcatCTM(bitmap, transform);
        CGContextDrawImage(bitmap, (transpose) ? transposedRect : newRect, imageRef);
        
        newImageRef = CGBitmapContextCreateImage(bitmap);
        newImage = [UIImage imageWithCGImage:newImageRef scale:self.scale orientation:UIImageOrientationUp];
        
        CGContextRelease(bitmap);
        CGImageRelease(newImageRef);
        
        return newImage;
    }
    
    return self;
}

@end