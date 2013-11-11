/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFSectionHeaderView : UIView
{
    @private
    UILabel *m_titleLabel;
}

+ (CGFloat)preferredHeight;

- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor;

@property (nonatomic, retain) NSString *title;

@end
