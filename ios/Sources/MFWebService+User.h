/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequest.h"
#import "MFWebService.h"

@class MFUserDetails;

@interface MFWebService(User)

- (void)requestUserDetails:(NSString *)identifier target:(id)target usingBlock:(MFWebRequestBlock)block;
- (void)requestUserEdit:(MFUserDetails *)user target:(id)target usingBlock:(MFWebRequestBlock)block;

@end
