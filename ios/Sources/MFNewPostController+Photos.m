/* Copyright (c) 2013 Meep Factory OU */

#import "MFNewPostController+Photos.h"
#import "MFNewPostPageView.h"
#import "MFNewPostPhotoView.h"
#import "NSFileManager+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define THUMBNAIL_COUNT 4
#define THUMBNAIL_PADDING 10.0F
#define ACTIONBAR_HEIGHT 46.0F

@interface MFNewPostController_Photos : MFNewPostPageView <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    @private
    NSMutableDictionary *m_imagePaths;
    MFNewPostPhotoView *m_imageView;
    NSMutableArray *m_thumbnailViews;
    UILabel *m_cameraOverlayView;
    BOOL m_canContinue;
}

- (id)initWithFrame:(CGRect)frame controller:(MFNewPostController *)controller;

@property (nonatomic, assign, readonly) NSInteger selectedImageIndex;

@end
//320x380
@implementation MFNewPostController_Photos

@dynamic selectedImageIndex;

- (NSInteger)selectedImageIndex
{
    for(NSInteger i = 0, c = m_thumbnailViews.count; i < c; i++) {
        MFNewPostPhotoView *thumbnailView = [m_thumbnailViews objectAtIndex:i];
        
        if(thumbnailView.selected) {
            return i;
        }
    }
    
    return 0;
}

- (IBAction)selectImage:(id)sender
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    
    controller.delegate = self;
    controller.allowsEditing = YES;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if(m_cameraOverlayView) {
            m_cameraOverlayView.text = NSLocalizedString(@"NewPost.Hint.Photo.1", nil);
            controller.cameraOverlayView = m_cameraOverlayView;
        }
    } else {
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [m_controller.navigationController presentViewController:controller animated:YES completion:NULL];
}

- (IBAction)selectThumbnail:(UIView *)sender
{
    MFNewPostPhotoView *oldThumbnailView = nil;
    MFNewPostPhotoView *newThumbnailView = nil;
    
    while(sender && ![sender isKindOfClass:[MFNewPostPhotoView class]]) {
        sender = sender.superview;
    }
    
    for(MFNewPostPhotoView *thumbnailView in m_thumbnailViews) {
        if(thumbnailView == sender) {
            newThumbnailView = thumbnailView;
        }
        
        if(thumbnailView.selected) {
            oldThumbnailView = thumbnailView;
        }
    }
    
    if(oldThumbnailView != newThumbnailView) {
        oldThumbnailView.selected = NO;
        newThumbnailView.selected = YES;
        m_imageView.image = newThumbnailView.image;
        m_imageView.imageIndex = newThumbnailView.imageIndex;
    }
}

- (IBAction)removeImage:(id)sender
{
    NSInteger selectedImageIndex = self.selectedImageIndex;
    NSNumber *key = [NSNumber numberWithInteger:selectedImageIndex];
    NSString *value;
    
    if((value = [m_imagePaths objectForKey:key]) != nil) {
        [[NSFileManager defaultManager] removeItemAtPath:value error:NULL];
        [m_imagePaths removeObjectForKey:key];
    }
    
    ((MFNewPostPhotoView *)[m_thumbnailViews objectAtIndex:selectedImageIndex]).image = nil;
    m_imageView.image = nil;
}

- (IBAction)replaceImage:(id)sender
{
    m_cameraOverlayView = nil;
    [self selectImage:nil];
}

#pragma mark MFNewPostPageView

- (id)initWithFrame:(CGRect)frame controller:(MFNewPostController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
        const CGFloat thumbnailSize = roundf((frame.size.width - THUMBNAIL_PADDING) / THUMBNAIL_COUNT) - THUMBNAIL_PADDING;
        CGRect thumbnailRect = CGRectMake(THUMBNAIL_PADDING, frame.size.height - thumbnailSize - ACTIONBAR_HEIGHT, thumbnailSize, thumbnailSize);
        UIButton *button;
        
        m_controller = controller;
        m_thumbnailViews = [[NSMutableArray alloc] init];
        m_imagePaths = [[NSMutableDictionary alloc] init];
        
        m_cameraOverlayView = [[UILabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 40.0F)];
        m_cameraOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        m_imageView = [[MFNewPostPhotoView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height - ACTIONBAR_HEIGHT)];
        m_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        m_imageView.imageIndex = 0;
        [m_imageView addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_imageView];
        
        for(NSInteger i = 0; i < THUMBNAIL_COUNT; i++, thumbnailRect.origin.x += THUMBNAIL_PADDING + thumbnailSize) {
            MFNewPostPhotoView *thumbnailView = [[MFNewPostPhotoView alloc] initWithFrame:thumbnailRect];
            
            thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
            thumbnailView.imageIndex = i;
            thumbnailView.selected = (i == 0) ? YES : NO;
            [thumbnailView addTarget:self action:@selector(selectThumbnail:) forControlEvents:UIControlEventTouchUpInside];
            [m_thumbnailViews addObject:thumbnailView];
            [self addSubview:thumbnailView];
        }
        
        button = [[UIButton alloc] initWithFrame:CGRectMake(0.0F, frame.size.height - ACTIONBAR_HEIGHT, 0.5F * frame.size.width, ACTIONBAR_HEIGHT)];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:NSLocalizedString(@"NewPost.Action.Remove", nil) forState:UIControlStateNormal];
        [self addSubview:button];
        
        button = [[UIButton alloc] initWithFrame:CGRectMake(0.5F * frame.size.width, frame.size.height - ACTIONBAR_HEIGHT, 0.5F * frame.size.width, ACTIONBAR_HEIGHT)];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:NSLocalizedString(@"NewPost.Action.Replace", nil) forState:UIControlStateNormal];
        [self addSubview:button];
    }
    
    return self;
}

- (BOOL)canContinue
{
    if(!m_canContinue) {
        m_canContinue = YES;//(m_imagePaths.count == THUMBNAIL_COUNT) ? YES : NO;
    }
    
    return m_canContinue;
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSInteger selectedImageIndex = self.selectedImageIndex;
    
    if(!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if(image) {
        NSNumber *key = [NSNumber numberWithInteger:selectedImageIndex];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        NSString *value = [m_imagePaths objectForKey:key];
        
        if(value) {
            [fileManager removeItemAtPath:value error:NULL];
        }
        
        if(data) {
            value = [fileManager pathForTemporaryFileWithPrefix:@"Photo"];
            
            if([data writeToFile:value atomically:YES]) {
                [m_imagePaths setObject:value forKey:key];
                [m_controller invalidateNavigation];
            } else {
                image = nil;
            }
        } else {
            image = nil;
        }
        
        ((MFNewPostPhotoView *)[m_thumbnailViews objectAtIndex:selectedImageIndex]).image = image;
        m_imageView.image = image;
        
        if(m_cameraOverlayView) {
            
        } else {
            [picker dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark NSObject

- (void)dealloc
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for(NSString *path in m_imagePaths.objectEnumerator) {
        [fileManager removeItemAtPath:path error:NULL];
    }
}

@end

#pragma mark -

@implementation MFNewPostController(Photos)

- (MFNewPostPageView *)createPhotosPageView
{
    return [[MFNewPostController_Photos alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
