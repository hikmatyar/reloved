/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFNewPostPhotoView : UIView
{
    @private
    NSInteger m_imageIndex;
    UIButton *m_placeholder;
    UIButton *m_button;
    UIImageView *m_imageView;
    BOOL m_thumbnail;
    BOOL m_selected;
}

- (id)initWithFrame:(CGRect)frame thumbnail:(BOOL)thumbnail;

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, assign, readonly, getter = isThumbnail) BOOL thumbnail;
@property (nonatomic, assign, getter = isSelected) BOOL selected;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
