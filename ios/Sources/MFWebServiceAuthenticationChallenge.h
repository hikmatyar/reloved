/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFWebAuthorization;

@protocol MFWebServiceAuthenticationChallenge <NSObject>

@required

- (void)abortAuthorization;
- (void)useAuthorization:(MFWebAuthorization *)authorization;
@property (nonatomic, assign, readonly) NSInteger failureCount;

@optional

- (void)resetFailureCount;

@end
