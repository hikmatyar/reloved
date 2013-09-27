/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@protocol MFHomeHeaderViewDelegate;
@class MFMenuItem;

@interface MFHomeHeaderView : UIView
{
    @private
    __unsafe_unretained id <MFHomeHeaderViewDelegate> m_delegate;
    MFMenuItem *m_item;
    UIImageView *m_itemImageView;
    UILabel *m_itemLabel;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, assign) id <MFHomeHeaderViewDelegate> delegate;
@property (nonatomic, retain) MFMenuItem *item;

@end
