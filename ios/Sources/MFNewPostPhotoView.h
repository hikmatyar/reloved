/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFNewPostPhotoView : UIView
{
    @private
    NSInteger m_imageIndex;
    UIButton *m_button;
    UIImageView *m_imageView;
    BOOL m_selected;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, assign, getter = isSelected) BOOL selected;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
