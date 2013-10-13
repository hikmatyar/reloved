/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequest.h"
#import "MFWebService.h"

@interface MFWebService(Media)

- (void)requestMediaIdentifier:(NSString *)csum size:(UInt64)size target:(id)target usingBlock:(MFWebRequestBlock)block;
- (void)requestMediaUpload:(NSString *)path identifier:(NSString *)identifier target:(id)target usingBlock:(MFWebRequestBlock)block;

@end
