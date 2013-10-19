/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@protocol MFHomeHeaderViewDelegate;
@class MFImageView, MFPost;

@interface MFHomeHeaderView : UIView
{
    @private
    __unsafe_unretained id <MFHomeHeaderViewDelegate> m_delegate;
    NSArray *m_posts;
    MFPost *m_selectedPost;
    MFImageView *m_postImageView;
    UILabel *m_postLabel;
    UIButton *m_prevButton;
    UIButton *m_nextButton;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, assign) id <MFHomeHeaderViewDelegate> delegate;
@property (nonatomic, retain) NSArray *posts;
@property (nonatomic, retain, readonly) MFPost *selectedPost;

@end
