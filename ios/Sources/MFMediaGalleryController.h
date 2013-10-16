/* Copyright (c) 2013 Meep Factory OU */

#import "UIPhotoGalleryView.h"
#import "UIPhotoGalleryViewController.h"

@interface MFMediaGalleryController : UIPhotoGalleryViewController
{
    @private
    NSArray *m_mediaIds;
}

@property (nonatomic, retain) NSArray *mediaIds;

@end
