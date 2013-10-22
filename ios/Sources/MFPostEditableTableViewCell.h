/* Copyright (c) 2013 Meep Factory OU */

#import "MFTableViewCell.h"

@class MFPost;

@interface MFPostEditableTableViewCell : MFTableViewCell
{
    @private
    MFPost *m_post;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, retain) MFPost *post;

@end
