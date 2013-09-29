/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFWebPost;

@interface MFPostController : UIViewController
{
    @private
    MFWebPost *m_post;
}

- (id)initWithPost:(MFWebPost *)post;

@end
