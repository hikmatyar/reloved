/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFProgressView;

@protocol MFProgressViewDelegate <NSObject>

@optional

- (BOOL)progressView:(MFProgressView *)progressView shouldSelectItemAtIndex:(NSInteger)index;
- (void)progressView:(MFProgressView *)progressView didSelectItemAtIndex:(NSInteger)index;

@end
