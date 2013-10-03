/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@protocol MFFormElement <NSObject>

@end

@interface MFForm : UIScrollView

- (void)scrollToView:(UIView *)view animated:(BOOL)animated;

@end
