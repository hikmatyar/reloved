/* Copyright (c) 2013 Meep Factory OU */

#import "MFPost.h"
#import "MFPostTableViewCell.h"

@implementation MFPostTableViewCell

+ (CGFloat)preferredHeight
{
    return 56.0F;
}

@dynamic post;

- (MFPost *)post
{
    return m_post;
}

- (void)setPost:(MFPost *)post
{
}

@end
