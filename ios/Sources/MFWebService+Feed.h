/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequest.h"
#import "MFWebService.h"

@interface MFWebService(Feed)

- (void)requestGlobals:(NSString *)globals target:(id)target usingBlock:(MFWebRequestBlock)block;
- (void)requestFeed:(NSString *)identifier clientCount:(NSInteger)clientCount forward:(BOOL)forward limit:(NSInteger)limit state:(NSString *)state globals:(NSString *)globals target:(id)target usingBlock:(MFWebRequestBlock)block;
- (void)requestPosts:(NSArray *)postIds lastModification:(NSDate *)lastModification target:(id)target usingBlock:(MFWebRequestBlock)block;

@end
