/* Copyright (c) 2013 Meep Factory OU */

#import "MFImageView.h"
#import "MFWebCache.h"
#import "MFWebResource.h"
#import "MFWebService.h"

@implementation MFImageView

- (void)loadImage
{
    if(m_resource.filePath) {
        MFWebResource *resource = m_resource;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^() {
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:resource.filePath];
			
            dispatch_async(dispatch_get_main_queue(), ^() {
                if(m_URL && [m_URL.absoluteString isEqualToString:resource.URL.absoluteString]) {
                    [m_activityIndicatorView stopAnimating];
                    self.image = image;
                    
                    if(m_completedBlock) {
                        m_completedBlock(image, nil);
                        self.completedBlock = nil;
                    }
                }
            });
        });
    } else {
        [m_activityIndicatorView stopAnimating];
        
        if(m_completedBlock) {
            m_completedBlock(nil, m_resource.error);
            self.completedBlock = nil;
        }
    }
}

- (void)startLoading
{
    if(!m_resource && m_URL) {
        MFWebCache *cache = [MFWebService sharedService].cache;
        
        m_resource = [cache resourceForURL:m_URL];
        [m_activityIndicatorView startAnimating];
        
        if(!m_resource) {
            m_resource = [MFWebResource nullResource];
            
            [cache requestResource:m_URL target:self usingBlock:^(id target, NSError *error, MFWebResource *resource) {
                m_resource = (error) ? [MFWebResource errorResource] : resource;
                [self loadImage];
            }];
        } else {
            [self loadImage];
        }
    }
}

- (void)stopLoading
{
    if(m_resource) {
        [[MFWebService sharedService].cache cancelResourcesForTarget:self];
        [m_activityIndicatorView stopAnimating];
        m_resource = nil;
    }
}

@synthesize activityIndicatorView = m_activityIndicatorView;
@synthesize completedBlock = m_completedBlock;

@dynamic URL;

- (NSURL *)URL
{
    return m_URL;
}

- (void)setURL:(NSURL *)URL
{
    if(URL != m_URL && (!URL || ![m_URL isEqual:URL])) {
        [self stopLoading];
        
        m_URL = URL;
        m_resource = nil;
        self.image = nil;
        
        if(m_URL) {
            [self startLoading];
        }
    } else if(m_completedBlock) {
        m_completedBlock(self.image, nil);
        self.completedBlock = nil;
    }
}

- (void)loadURL:(NSURL *)URL completed:(MFImageViewCompletedBlock)block
{
    self.completedBlock = block;
    self.URL = URL;
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        m_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        m_activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        m_activityIndicatorView.center = CGPointMake(round(frame.size.width * 0.5F), round(frame.size.height * 0.5F));
        [self addSubview:m_activityIndicatorView];
    }
    
    return self;
}

- (void)didMoveToWindow
{
    if(self.window) {
        if(m_URL && !self.image) {
            [self startLoading];
        }
    } else {
        [self stopLoading];
    }
    
    [super didMoveToWindow];
}

@end
