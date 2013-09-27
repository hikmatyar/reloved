/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFSeparatorView : UIView
{
    @private
    UIView *m_bottomView;
}

- (id)initWithPosition:(CGFloat)position;

@property (nonatomic, retain) UIColor *topColor;
@property (nonatomic, retain) UIColor *bottomColor;

@end
