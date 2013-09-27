/* Copyright (c) 2013 Meep Factory OU */

#import "MFImageButton.h"

@implementation MFImageButton

@synthesize imageTopPadding = m_imageTopPadding;
@synthesize textTopPadding = m_textTopPadding;

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        m_imageTopPadding = -2.0F;
        m_textTopPadding = -2.0F;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    {
        CGRect titleLabelFrame = self.titleLabel.frame;
        CGSize labelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect imageFrame = self.imageView.frame;
        CGSize fitBoxSize = { MAX(imageFrame.size.width, labelSize.width), labelSize.height + m_textTopPadding + imageFrame.size.height };
        CGRect fitBoxRect = CGRectInset(self.bounds, 0.5F * (self.bounds.size.width - fitBoxSize.width), 0.5F * (self.bounds.size.height - fitBoxSize.height));
        
        imageFrame.origin.y = fitBoxRect.origin.y + m_imageTopPadding;
        imageFrame.origin.x = CGRectGetMidX(fitBoxRect) - 0.5F * imageFrame.size.width;
        self.imageView.frame = imageFrame;
        
        titleLabelFrame.size.width = labelSize.width;
        titleLabelFrame.size.height = labelSize.height;
        titleLabelFrame.origin.x = 0.5F * (self.frame.size.width - labelSize.width);
        titleLabelFrame.origin.y = fitBoxRect.origin.y + imageFrame.size.height + m_textTopPadding + m_imageTopPadding;
        self.titleLabel.frame = titleLabelFrame;
    }
}

@end
