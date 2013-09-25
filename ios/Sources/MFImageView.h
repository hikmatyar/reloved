/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

typedef void (^MFImageViewCompletedBlock)(UIImage *image, NSError *error);

@interface MFImageView : UIImageView
{
    @private
    NSURL *m_url;
}

@property (nonatomic, retain) NSURL *URL;
- (void)loadURL:(NSURL *)URL completed:(MFImageViewCompletedBlock)block;

@end
