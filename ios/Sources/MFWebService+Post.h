/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequest.h"
#import "MFWebService.h"

@interface MFWebService(Post)

- (void)requestPost:(MFMutablePost *)post target:(id)target usingBlock:(MFWebRequestBlock)block;

@end
