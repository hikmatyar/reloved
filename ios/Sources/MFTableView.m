/* Copyright (c) 2013 Meep Factory OU */

#import "MFTableView.h"
#import "MFWebCache.h"
#import "MFWebResource.h"
#import "MFWebService.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define TAG_PLACEHOLDER 10000

@interface UITableViewCell(Extensions)

- (void)prepareForDisplay;

@end

@implementation MFTableView

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

- (UILabel *)placeholderLabel
{
	for(UIView *subview in self.subviews) {
		if(subview.tag == TAG_PLACEHOLDER && [subview isKindOfClass:[UILabel class]]) {
			return (UILabel *)subview;
		}
	}
	
	return nil;
}

@dynamic placeholder;

- (NSString *)placeholder
{
	return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
	self.placeholderLabel.text = placeholder;
}

#pragma mark UITableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    
    if(self) {
        UILabel *placeholderLabel;
        
        m_images = [[NSMutableDictionary alloc] init];
        m_resources = [[NSMutableDictionary alloc] init];
        self.rowHeight = 44.0F;
        
        placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0F, floor(frame.size.height * 0.5F / self.rowHeight) * self.rowHeight, frame.size.width - 10.0F, self.rowHeight)];
		placeholderLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		placeholderLabel.userInteractionEnabled = NO;
		placeholderLabel.backgroundColor = [UIColor clearColor];
		placeholderLabel.font = [UIFont themeBoldFontOfSize:20.0F];
		placeholderLabel.hidden = YES;
		placeholderLabel.tag = TAG_PLACEHOLDER;
		placeholderLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		placeholderLabel.opaque = NO;
        placeholderLabel.numberOfLines = 0;
		placeholderLabel.textAlignment = NSTextAlignmentCenter;
		placeholderLabel.textColor = [[UIColor themeTextAlternativeColor] colorWithAlphaComponent:0.5F];
		[self addSubview:placeholderLabel];
    }
    
    return self;
}

- (void)setRowHeight:(CGFloat)rowHeight
{
	super.rowHeight = rowHeight;
	self.placeholderLabel.frame = CGRectMake(0.0F, (m_placeholderOffset < 1.0F) ? floor(self.frame.size.height * 0.5F / self.rowHeight) * self.rowHeight : m_placeholderOffset, self.frame.size.width, self.rowHeight);
}

- (void)reloadData
{
	//[self stopLoading];
    [super reloadData];
    
	self.placeholderLabel.hidden = (self.visibleCells.count > 0) ? YES : NO;
}

- (void)endUpdates
{
	[super endUpdates];
    
	self.placeholderLabel.hidden = (self.visibleCells.count > 0) ? YES : NO;
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

- (void)setFrame:(CGRect)frame
{
	super.frame = frame;
	self.placeholderLabel.frame = CGRectMake(0.0F, (m_placeholderOffset < 1.0F) ? floor(self.frame.size.height * 0.5F / self.rowHeight) * self.rowHeight : m_placeholderOffset, self.frame.size.width, self.rowHeight);
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
