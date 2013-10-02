/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFNewPostProgressView;

@protocol MFNewPostProgressViewDelegate <NSObject>

@optional

- (BOOL)progressView:(MFNewPostProgressView *)progressView shouldSelectItemAtIndex:(NSInteger)index;
- (void)progressView:(MFNewPostProgressView *)progressView didSelectItemAtIndex:(NSInteger)index;

@end
