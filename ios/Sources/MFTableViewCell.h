/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFTableViewCell : UITableViewCell
{
    @private
    UIColor *m_backgroundNormalColor;
    UIColor *m_backgroundHighlightColor;
}

- (UIImage *)imageForURL:(NSURL *)URL;
- (UIImage *)imageForURL:(NSURL *)URL error:(NSError **)error exists:(BOOL *)exists;

@property (nonatomic, retain) UIColor *backgroundNormalColor;
@property (nonatomic, retain) UIColor *backgroundHighlightColor;

- (void)prepareForDisplay;

@end
