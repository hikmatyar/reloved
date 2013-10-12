/* Copyright (c) 2013 Meep Factory OU */

#import "MFImageButton.h"
#import "MFNewPostPhotoView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFNewPostPhotoView

- (id)initWithFrame:(CGRect)frame thumbnail:(BOOL)thumbnail
{
    self = [super initWithFrame:frame];
    
    if(self) {
        m_imageIndex = NSNotFound;
        m_selected = NO;
        m_thumbnail = thumbnail;
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor themeButtonBackgroundColor];
        self.layer.borderColor = [UIColor themeButtonBorderColor].CGColor;
        self.layer.borderWidth = 1.0F;
        
        m_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        m_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:m_imageView];
        
        m_placeholder = [[MFImageButton alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height - ((m_thumbnail) ? 0.0F : 60.0F))];
        m_placeholder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        m_placeholder.titleLabel.font = [UIFont themeFontOfSize:(m_thumbnail) ? 9.0F : 15.0F];
        ((MFImageButton *)m_placeholder).textTopPadding = 3.0F;
        [m_placeholder setImage:[UIImage imageNamed:(m_thumbnail) ? @"NewPost-Photos-Thumbnail.png" : @"NewPost-Photos-Placeholder.png"] forState:UIControlStateNormal];
        [m_placeholder setTitleColor:[UIColor themeTextColor] forState:UIControlStateNormal];
        [self addSubview:m_placeholder];
        
        m_button = [[UIButton alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        m_button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:m_button];
    }
    
    return self;
}

@dynamic image;

- (UIImage *)image
{
    return m_imageView.image;
}

- (void)setImage:(UIImage *)image
{
    m_imageView.image = image;
    m_placeholder.hidden = (image) ? YES : NO;
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
        [m_placeholder setTitle:(m_imageIndex != NSNotFound) ?
            [NSString stringWithFormat:NSLocalizedString((m_thumbnail) ? @"NewPost.Format.Photo.Short" : @"NewPost.Format.Photo.Long", nil), (m_imageIndex + 1)] : @"" forState:UIControlStateNormal];
    }
}

@synthesize thumbnail = m_thumbnail;

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
    return [self initWithFrame:frame thumbnail:NO];
}

@end
