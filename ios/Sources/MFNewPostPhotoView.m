/* Copyright (c) 2013 Meep Factory OU */

#import "MFNewPostPhotoView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFNewPostPhotoView

@dynamic image;

- (UIImage *)image
{
    return m_imageView.image;
}

- (void)setImage:(UIImage *)image
{
    m_imageView.image = image;
    //m_button.alpha = (image) ? 0.0F : 1.0F;
}

@dynamic imageIndex;

- (NSInteger)imageIndex
{
    return m_imageIndex;
}

- (void)setImageIndex:(NSInteger)imageIndex
{
    if(m_imageIndex != imageIndex) {
        m_imageIndex = imageIndex;
        
        [m_button setTitle:(m_imageIndex != NSNotFound) ? [NSString stringWithFormat:@"%d", (m_imageIndex + 1)] : @"" forState:UIControlStateNormal];
    }
}

@dynamic selected;

- (BOOL)isSelected
{
    return m_selected;
}

- (void)setSelected:(BOOL)selected
{
    if(m_selected != selected) {
        m_selected = selected;
        self.layer.borderColor = (m_selected) ? [UIColor themeButtonBorderSelectedColor].CGColor : [UIColor themeButtonBorderColor].CGColor;
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [m_button addTarget:target action:action forControlEvents:controlEvents];
}

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [m_button removeTarget:target action:action forControlEvents:controlEvents];
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        m_imageIndex = NSNotFound;
        m_selected = NO;
        
        self.backgroundColor = [UIColor themeButtonBackgroundColor];
        self.layer.borderColor = [UIColor themeButtonBorderColor].CGColor;
        self.layer.borderWidth = 1.0F;
        
        m_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        m_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:m_imageView];
        
        m_button = [[UIButton alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        m_button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [m_button setTitleColor:[UIColor themeTextColor] forState:UIControlStateNormal];
        [self addSubview:m_button];
    }
    
    return self;
}

@end
