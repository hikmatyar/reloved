/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase+State.h"
#import "MFImageView.h"
#import "MFPost.h"
#import "MFPostHeaderView.h"
#import "MFPostHeaderViewDelegate.h"
#import "MFPostTableViewCell.h"
#import "MFWebCache.h"
#import "MFWebResource.h"
#import "MFWebService.h"
#import "UIColor+Additions.h"

@interface UITableViewCell(Extensions)

- (void)prepareForDisplay;

@end

#pragma mark -

@interface MFPostTableViewCell_Header : MFPostTableViewCell
{
    @private
    UIScrollView *m_scrollView;
}

@end

@implementation MFPostTableViewCell_Header

#pragma mark MFPostTableViewCell

+ (CGFloat)preferredHeight
{
    return [super preferredHeight] + 56.0F;
}

- (void)setPost:(MFPost *)post
{
    CGRect thumbnailRect = CGRectMake(10.0F, 0.0F, 40.0F, 40.0F);
    MFDatabase *database = [MFDatabase sharedDatabase];
    
    super.post = post;
    
    for(UIView *view in m_scrollView.subviews) {
        if([view isKindOfClass:[MFImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    for(NSString *mediaId in post.mediaIds) {
        MFImageView *imageView = [[MFImageView alloc] initWithFrame:thumbnailRect];
        
        imageView.layer.borderWidth = 1.0F;
        imageView.layer.borderColor = [UIColor themeButtonBorderColor].CGColor;
        imageView.URL = [database URLForMedia:mediaId size:kMFMediaSizeThumbnailSmall];
        [m_scrollView addSubview:imageView];
        thumbnailRect.origin.x += thumbnailRect.size.width + 10.0F;
    }
    
    m_scrollView.contentSize = CGSizeMake(thumbnailRect.origin.x, thumbnailRect.origin.y + thumbnailRect.size.height);
}

#pragma mark UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 100.0F, 40.0F)];
        m_scrollView.directionalLockEnabled = YES;
        m_scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:m_scrollView];
    }
    
    return self;
}

#pragma mark UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.0F, 0.0F, 300.0F, 285.0F);
    m_scrollView.frame = CGRectMake(0.0F, 296.0F, 320.0F, 40.0F);
    self.textLabel.frame = CGRectMake(10.0F, 290.0F + 56.0F, 300.0F, 180.0F);
}

@end

#pragma mark -

@implementation MFPostHeaderView

+ (CGFloat)preferredHeight
{
    return [MFPostTableViewCell_Header preferredHeight];
}

- (void)loadResource:(NSURL *)URL
{
    MFWebResource *resource = [m_resources objectForKey:URL];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^() {
        UIImage *image_ = (!resource.error && resource.filePath) ? [[UIImage alloc] initWithContentsOfFile:resource.filePath] : nil;
        
        dispatch_async(dispatch_get_main_queue(), ^() {
            NSSet *cells_ = [m_images objectForKey:URL];
            
            if([cells_ isKindOfClass:[NSSet class]]) {
                if(image_) {
                    [m_images setObject:image_ forKey:URL];
                } else {
                    [m_images removeObjectForKey:URL];
                    [m_resources setObject:[MFWebResource errorResource] forKey:URL];
                }
                
                for(UITableViewCell *cell in cells_) {
                    if([cell respondsToSelector:@selector(prepareForDisplay)]) {
                        [cell performSelector:@selector(prepareForDisplay)];
                    }
                }
            }
        });
    });
}

- (void)lowMemoryWarning:(NSNotification *)notification
{
    [self purgeCache];
}

- (void)purgeCache
{
    NSMutableSet *keysToPurge = [[NSMutableSet alloc] init];
    
    for(NSString *key in m_images.keyEnumerator) {
        if([[m_images objectForKey:key] isKindOfClass:[UIImage class]]) {
            [keysToPurge addObject:key];
        }
    }
    
    for(NSString *key in keysToPurge) {
        [m_images removeObjectForKey:key];
    }
}

@synthesize delegate = m_delegate;

@dynamic post;

- (MFPost *)post
{
    return m_cell.post;
}

- (void)setPost:(MFPost *)post
{
    m_cell.post = post;
}

#pragma mark MFTableView

- (UIImage *)startLoadingForCell:(UITableViewCell *)cell URL:(NSURL *)URL error:(NSError **)error exists:(BOOL *)exists
{
    UIImage *image = nil;
    
    if(error) {
        *error = nil;
    }
    
    if(exists) {
        *exists = NO;
    }
    
    if(URL) {
        image = [m_images objectForKey:URL];
        
        if([image isKindOfClass:[NSMutableSet class]]) {
            [(NSMutableSet *)image addObject:cell];
            image = nil;
            
            if(exists) {
                *exists = YES;
            }
        } else if(!image) {
            MFWebResource *resource = [m_resources objectForKey:URL];
            
            if(!resource) {
                MFWebCache *cache = [MFWebService sharedService].cache;
                
                resource = [cache resourceForURL:URL];
                
                if(!resource) {
                    NSMutableSet *cells = [NSMutableSet set];
                    
                    resource = [MFWebResource nullResource];
                    [m_resources setObject:resource forKey:URL];
                    
                    [cells addObject:cell];
                    [m_images setObject:cells forKey:URL];
                    
                    [cache requestResource:URL target:self usingBlock:^(id target, NSError *error, MFWebResource *resource) {
                        if(error) {
                            [m_resources setObject:[MFWebResource errorResource] forKey:URL];
                        } else {
                            [m_resources setObject:resource forKey:URL];
                        }
                        
                        [self loadResource:URL];
                    }];
                } else {
                    [m_resources setObject:resource forKey:URL];
                }
            }
            
            if(resource.error) {
                if(error) {
                    *error = resource.error;
                }
            } else if(resource.filePath) {
                NSMutableSet *cells = [NSMutableSet set];
                
                [cells addObject:cell];
                [m_images setObject:cells forKey:URL];
                
                if(exists) {
                    *exists = YES;
                }
                
                [self loadResource:URL];
            }
        }
    }
    
    return image;
}

- (void)stopLoading
{
    if(m_resources.count > 0) {
        [[MFWebService sharedService].cache cancelResourcesForTarget:self];
        [m_resources removeAllObjects];
    }
    
    [m_images removeAllObjects];
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        m_images = [[NSMutableDictionary alloc] init];
        m_resources = [[NSMutableDictionary alloc] init];
        m_cell = [[MFPostTableViewCell_Header alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        m_cell.frame = CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height);
        [self addSubview:m_cell];
    }
    
    return self;
}

- (void)didMoveToWindow
{
    if(self.window) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lowMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [self stopLoading];
    }
    
    [super didMoveToWindow];
}

@end