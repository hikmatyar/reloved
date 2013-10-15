/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFWebResource, MFWebService;

typedef void (^MFWebCacheBlock)(id target, NSError *error, MFWebResource *resource);

@interface MFWebCache : NSObject
{
    @private
    NSString *m_cacheDirectory;
    NSInteger m_cacheSize;
    NSMutableDictionary *m_resources;
    __unsafe_unretained MFWebService *m_service;
}

- (id)initWithService:(MFWebService *)service;

- (NSArray *)availableResources;
- (MFWebResource *)resourceForURL:(NSURL *)URL;
- (void)removeResourceForURL:(NSURL *)URL;

- (void)requestResource:(NSURL *)resource target:(id)target usingBlock:(MFWebCacheBlock)block;
- (void)cancelResourcesForTarget:(id)target;
- (void)cancelAllResources;

@end
