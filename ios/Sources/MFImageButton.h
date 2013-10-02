/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFImageButton : UIButton
{
    @private
    CGFloat m_imageTopPadding;
    CGFloat m_textTopPadding;
    CGFloat m_verticalBias;
}

@property (nonatomic, assign) CGFloat imageTopPadding;
@property (nonatomic, assign) CGFloat textTopPadding;
@property (nonatomic, assign) CGFloat verticalBias;

@end
