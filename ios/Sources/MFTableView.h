/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@protocol MFTableView <NSObject>

@required

- (UIImage *)startLoadingForCell:(UITableViewCell *)cell URL:(NSURL *)URL error:(NSError **)error exists:(BOOL *)exists;
- (void)stopLoading;

@end

@interface MFTableView : UITableView <MFTableView>
{
    @private
    NSMutableDictionary *m_images;
    NSMutableDictionary *m_resources;
    CGFloat m_placeholderOffset;
}

@property (nonatomic, retain) NSString *placeholder;

- (void)purgeCache;

@end
