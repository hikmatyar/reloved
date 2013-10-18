/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@protocol MFHomeHeaderViewDelegate;
@class MFImageView, MFPost;

@interface MFHomeHeaderView : UIView
{
    @private
    __unsafe_unretained id <MFHomeHeaderViewDelegate> m_delegate;
    MFPost *m_post;
    MFImageView *m_postImageView;
    UILabel *m_postLabel;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, assign) id <MFHomeHeaderViewDelegate> delegate;
@property (nonatomic, retain) MFPost *post;

@end
