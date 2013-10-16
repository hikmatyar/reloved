/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface UIApplication(Additions)

- (void)sendEmail:(NSString *)email;
- (void)sendEmail:(NSString *)email subject:(NSString *)subject body:(NSString *)body;

@end
