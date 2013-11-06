/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@protocol MFPostFooterViewDelegate;

@interface MFPostFooterView : UIView
{
    @private
    __unsafe_unretained id <MFPostFooterViewDelegate> m_delegate;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, assign) id <MFPostFooterViewDelegate> delegate;
@property (nonatomic, retain, readonly) UIButton *leftButton;
@property (nonatomic, retain, readonly) UIButton *middleButton;
@property (nonatomic, retain, readonly) UIButton *rightButton;

@property (nonatomic, retain) NSString *leftTitle;

@end
