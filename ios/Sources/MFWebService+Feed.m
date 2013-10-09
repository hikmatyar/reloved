/* Copyright (c) 2013 Meep Factory OU */

#import "MFFeed.h"
#import "MFWebService+Feed.h"

@implementation MFWebService(Feed)

- (void)requestGlobals:(NSString *)globals target:(id)target usingBlock:(MFWebRequestBlock)block
{
    MFWebRequest *request = [[MFWebRequest alloc] initWithService:self
                                                             mode:kMFWebRequestModeJsonPost
                                                           target:target
                                                             path:@"/globals"
                                                       parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  (globals) ? globals : [NSNull null], @"state",
                                                                  nil]];
    
    request.block = block;
    request.transform = [MFFeed class];
    [self addRequest:request];
}

- (void)requestFeed:(NSString *)identifier forward:(BOOL)forward limit:(NSInteger)limit state:(NSString *)state globals:(NSString *)globals target:(id)target usingBlock:(MFWebRequestBlock)block
{
    MFWebRequest *request = [[MFWebRequest alloc] initWithService:self
                                                             mode:kMFWebRequestModeJsonPost
                                                           target:target
                                                             path:@"/browse"
                                                       parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  (forward) ? @"forward" : @"backward", @"direction",
                                                                  [NSNumber numberWithInteger:limit], @"limit",
                                                                  (identifier) ? identifier : [NSNull null], @"id",
                                                                  (globals) ? globals : [NSNull null], @"globals",
                                                                  nil]]; //state, @"state", nil]];
    
    request.block = block;
    request.transform = [MFFeed class];
    [self addRequest:request];
}

@end
