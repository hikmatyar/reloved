/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase+State.h"
#import "MFMediaGalleryController.h"

@implementation MFMediaGalleryController

@dynamic mediaIds;

- (NSArray *)mediaIds
{
    return m_mediaIds;
}

- (void)setMediaIds:(NSArray *)mediaIds
{
    if(!MFEqual(m_mediaIds, mediaIds)) {
        m_mediaIds = mediaIds;
        
    }
}

#pragma mark UIPhotoGalleryDataSource

- (NSInteger)numberOfViewsInPhotoGallery:(UIPhotoGalleryView *)photoGallery
{
    return m_mediaIds.count;
}

- (NSURL *)photoGallery:(UIPhotoGalleryView *)photoGallery remoteImageURLAtIndex:(NSInteger)index
{
    return [[MFDatabase sharedDatabase] URLForMedia:[m_mediaIds objectAtIndex:index] size:kMFMediaSizePhoto];
}

#pragma mark UIPhotoGalleryDelegate

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        self.dataSource = self;
        self.galleryMode = UIPhotoGalleryModeImageRemote;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    return self;
}

@end
