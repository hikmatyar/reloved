/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

typedef void (^MFImageViewCompletedBlock)(UIImage *image, NSError *error);

@class MFWebResource;

@interface MFImageView : UIImageView
{
    @private
    UIActivityIndicatorView *m_activityIndicatorView;
    MFImageViewCompletedBlock m_completedBlock;
    MFWebResource *m_resource;
    UIImage *m_placeholderImage;
    NSURL *m_URL;
}

@property (nonatomic, retain, readonly) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, copy) MFImageViewCompletedBlock completedBlock;
@property (nonatomic, retain) UIImage *placeholderImage;

@property (nonatomic, retain) NSURL *URL;
- (void)loadURL:(NSURL *)URL completed:(MFImageViewCompletedBlock)block;

@end
