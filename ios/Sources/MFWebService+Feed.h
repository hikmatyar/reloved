/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequest.h"
#import "MFWebService.h"

@interface MFWebService(Feed)

- (void)requestFeed:(NSString *)identifier forward:(BOOL)forward limit:(NSInteger)limit state:(NSString *)state target:(id)target usingBlock:(MFWebRequestBlock)block;

@end
