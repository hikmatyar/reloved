/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFWebPost;

@interface MFPostCommentsController : UIViewController
{
    @private
    MFWebPost *m_post;
}

- (id)initWithPost:(MFWebPost *)post;

@property (nonatomic, retain, readonly) MFWebPost *post;

@end
