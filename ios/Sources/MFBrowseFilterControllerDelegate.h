/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFBrowseFilterController;

@protocol MFBrowseFilterControllerDelegate <NSObject>

@optional

- (void)filterControllerDidClose:(MFBrowseFilterController *)controller;

@end
