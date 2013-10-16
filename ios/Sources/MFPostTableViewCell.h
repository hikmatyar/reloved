/* Copyright (c) 2013 Meep Factory OU */

#import "MFTableViewCell.h"

@class MFPost;

@interface MFPostTableViewCell : MFTableViewCell
{
    @private
    NSInteger m_selectedImageIndex;
    MFPost *m_post;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, retain) MFPost *post;
@property (nonatomic, assign) NSInteger selectedImageIndex;

@end
