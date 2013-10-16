/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@protocol MFPostHeaderViewDelegate;

@interface MFPostHeaderView : UIView
{
    @private
    __unsafe_unretained id <MFPostHeaderViewDelegate> m_delegate;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, assign) id <MFPostHeaderViewDelegate> delegate;

@end
