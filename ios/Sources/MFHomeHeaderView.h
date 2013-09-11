/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@protocol MFHomeHeaderViewDelegate;

@interface MFHomeHeaderView : UIView
{
    @private
    __unsafe_unretained id <MFHomeHeaderViewDelegate> m_delegate;
}

@property (nonatomic, assign) id <MFHomeHeaderViewDelegate> delegate;

@end
