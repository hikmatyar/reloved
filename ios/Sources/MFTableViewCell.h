/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFTableViewCell : UITableViewCell

- (UIImage *)imageForURL:(NSURL *)URL;
- (UIImage *)imageForURL:(NSURL *)URL error:(NSError **)error exists:(BOOL *)exists;

- (void)prepareForDisplay;

@end
