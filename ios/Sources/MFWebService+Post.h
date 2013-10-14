/* Copyright (c) 2013 Meep Factory OU */

#import "MFPost.h"
#import "MFWebRequest.h"
#import "MFWebService.h"

@interface MFWebService(Post)

- (void)requestPostCreate:(MFMutablePost *)post target:(id)target usingBlock:(MFWebRequestBlock)block;
- (void)requestPostEdit:(MFPost *)post changes:(MFPostChange)changes target:(id)target usingBlock:(MFWebRequestBlock)block;

@end
