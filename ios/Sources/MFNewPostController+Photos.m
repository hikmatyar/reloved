/* Copyright (c) 2013 Meep Factory OU */

#import "MFNewPostController+Photos.h"
#import "MFNewPostPageView.h"
#import "MFNewPostPhotoView.h"
#import "MFPost.h"
#import "NSFileManager+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define THUMBNAIL_MIN 4
#define THUMBNAIL_COUNT 8
#define THUMBNAIL_PADDING 10.0F
#define THUMBNAIL_TOP 16.0F

@interface MFNewPostController_Photos : MFNewPostPageView <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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
            switch(self.selectedImageIndex) {
                case 0:
                    m_cameraOverlayView.text = NSLocalizedString(@"NewPost.Hint.Photo.1.Picker", nil);
                    break;
                case 1:
                    m_cameraOverlayView.text = NSLocalizedString(@"NewPost.Hint.Photo.2.Picker", nil);
                    break;
                case 2:
                    m_cameraOverlayView.text = NSLocalizedString(@"NewPost.Hint.Photo.3.Picker", nil);
                    break;
                case 3:
                    m_cameraOverlayView.text = NSLocalizedString(@"NewPost.Hint.Photo.4.Picker", nil);
                    break;
                case 4:
                    m_cameraOverlayView.text = NSLocalizedString(@"NewPost.Hint.Photo.5.Picker", nil);
                    break;
                case 5:
                    m_cameraOverlayView.text = NSLocalizedString(@"NewPost.Hint.Photo.6.Picker", nil);
                    break;
                case 6:
                    m_cameraOverlayView.text = NSLocalizedString(@"NewPost.Hint.Photo.7.Picker", nil);
                    break;
                case 7:
                    m_cameraOverlayView.text = NSLocalizedString(@"NewPost.Hint.Photo.8.Picker", nil);
                    break;
                default:
                    m_cameraOverlayView.text = @"";
                    break;
            }
            
            controller.cameraOverlayView = m_cameraOverlayView;
        }
    } else {
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [m_controller.navigationController presentViewController:controller animated:(sender) ? YES : NO completion:NULL];
}

- (IBAction)editImage:(UIView *)sender
{
    while(sender && ![sender isKindOfClass:[MFNewPostPhotoView class]]) {
        sender = sender.superview;
    }
    
    if(sender) {
        NSInteger selectedImageIndex = [m_thumbnailViews indexOfObject:sender];
        
        if(selectedImageIndex != NSNotFound) {
            NSNumber *key = [NSNumber numberWithInteger:selectedImageIndex];
            
            if([m_imagePaths objectForKey:key]) {
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"NewPost.Action.Cancel" , nil)
                                                     destructiveButtonTitle:NSLocalizedString(@"NewPost.Action.Remove" , nil)
                                                          otherButtonTitles:NSLocalizedString(@"NewPost.Action.Replace" , nil), nil];
                
                sheet.tag = selectedImageIndex;
                [sheet showInView:m_controller.view];
            }
        }
    }
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

#pragma mark MFNewPostPageView

- (id)initWithFrame:(CGRect)frame controller:(MFNewPostController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
        const CGFloat thumbnailSize = roundf((frame.size.width - THUMBNAIL_PADDING) / THUMBNAIL_MIN) - THUMBNAIL_PADDING;
        CGRect thumbnailRect = CGRectMake(THUMBNAIL_PADDING, THUMBNAIL_TOP, thumbnailSize, thumbnailSize);
        UIScrollView *thumbnailScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0F, frame.size.height - thumbnailSize - THUMBNAIL_TOP, frame.size.width, thumbnailSize + THUMBNAIL_TOP)];
        
        m_controller = controller;
        m_thumbnailViews = [[NSMutableArray alloc] init];
        m_imagePaths = [[NSMutableDictionary alloc] init];
        
        m_cameraOverlayView = [[UILabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 40.0F)];
        m_cameraOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        m_imageView = [[MFNewPostPhotoView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        m_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        m_imageView.imageIndex = 0;
        [m_imageView addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_imageView];
        
        for(NSInteger i = 0; i < THUMBNAIL_COUNT; i++, thumbnailRect.origin.x += THUMBNAIL_PADDING + thumbnailSize) {
            MFNewPostPhotoView *thumbnailView = [[MFNewPostPhotoView alloc] initWithFrame:thumbnailRect thumbnail:YES];
            
            thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
            thumbnailView.imageIndex = i;
            thumbnailView.selected = (i == 0) ? YES : NO;
            [thumbnailView.editButton addTarget:self action:@selector(editImage:) forControlEvents:UIControlEventTouchUpInside];
            [thumbnailView addTarget:self action:@selector(selectThumbnail:) forControlEvents:UIControlEventTouchUpInside];
            [m_thumbnailViews addObject:thumbnailView];
            [thumbnailScollView addSubview:thumbnailView];
        }
        
        thumbnailScollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        thumbnailScollView.showsVerticalScrollIndicator = NO;
        thumbnailScollView.directionalLockEnabled = YES;
        thumbnailScollView.contentSize = CGSizeMake(thumbnailRect.origin.x, thumbnailRect.origin.y + thumbnailRect.size.height);
        [self addSubview:thumbnailScollView];
    }
    
    return self;
}

- (BOOL)canContinue
{
    if(!m_canContinue) {
        m_canContinue = YES;//(m_imagePaths.count >= THUMBNAIL_MIN) ? YES : NO;
    }
    
    return m_canContinue;
}

- (void)submitting
{
    [m_imagePaths removeAllObjects];
}

#pragma mark MFPageView

- (void)pageDidDisappear
{
    NSMutableArray *imagePaths = [NSMutableArray array];
    
    for(NSNumber *key in [m_imagePaths.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
        NSString *path = [m_imagePaths objectForKey:key];
        
        [imagePaths addObject:path];
    }
    
    m_controller.post.imagePaths = imagePaths;
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)sheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(sheet.cancelButtonIndex != buttonIndex) {
        NSInteger selectedImageIndex = sheet.tag;
        NSNumber *key = [NSNumber numberWithInteger:selectedImageIndex];
        NSString *value = [m_imagePaths objectForKey:key];
        
        if(value) {
            if(sheet.destructiveButtonIndex == buttonIndex) {
                [[NSFileManager defaultManager] removeItemAtPath:value error:NULL];
                [m_imagePaths removeObjectForKey:key];
                ((MFNewPostPhotoView *)[m_thumbnailViews objectAtIndex:selectedImageIndex]).image = nil;
                m_imageView.image = nil;
            } else {
                m_cameraOverlayView = nil;
                [self selectImage:nil];
            }
        }
    }
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
        
        if(selectedImageIndex + 1 < m_thumbnailViews.count) {
            [self selectThumbnail:[m_thumbnailViews objectAtIndex:selectedImageIndex + 1]];
        } else {
            m_cameraOverlayView = nil;
        }
        
        if(m_cameraOverlayView) {
            [picker dismissViewControllerAnimated:NO completion:NULL];
            [self selectImage:nil];
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
