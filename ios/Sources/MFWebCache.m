/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebCache.h"
#import "MFWebRequest.h"
#import "MFWebResource.h"
#import "MFWebService.h"
#import "MFWebServiceError.h"
#import "NSData+Additions.h"

@interface MFWebCache_Resource : NSObject
{
    @public
    MFWebResource *m_resource;
    NSInteger m_usageCount;
    BOOL m_markedForDeletion;
    NSMutableArray *m_requests;
}

@end

@implementation MFWebCache_Resource

@end

#pragma mark -

@interface MFWebCache_Request : MFWebRequest

@end

@implementation MFWebCache_Request

- (void)handleResponse
{
    NSString *path = self.downloadDestinationPath;
    
    if(path) {
        NSError *err = nil;
        
        if(![[NSURL fileURLWithPath:path] setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&err]){
            MFLog(@"Error excluding %@ from backup %@", path, err);
        }
    }
    
    if(!self.isCancelled) {
        m_block(m_target, nil, nil);
    }
}

#pragma mark HTTPASIRequest

- (void)setPostValue:(id <NSObject>)value forKey:(NSString *)key
{
    if(value && key) {
        NSString *str = self.url.absoluteString;
        NSString *value_ = @"";
        NSURL *url_;
        
        if([value isKindOfClass:[NSString class]]) {
            value_ = (NSString *)value;
        } else if([value isKindOfClass:[NSNumber class]]) {
            value_ = ((NSNumber *)value).stringValue;
        }
        
        str = [str stringByAppendingFormat:@"%@%@=%@", (([str rangeOfString:@"?"].location == NSNotFound) ? @"?" : @"&"), [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [value_ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        url_ = [NSURL URLWithString:str];
        
        if(url_) {
            self.url = url_;
        }
    }
}

@end

#pragma mark -

@implementation MFWebCache

- (id)initWithService:(MFWebService *)service
{
    self = [super init];
    
    if(self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *enumerator;
        NSString *path;
        
        m_cacheDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"www"];
        m_cacheSize = 32 * 1024 * 1024; // 32 MiB
        m_resources = [[NSMutableDictionary alloc] init];
        m_service = service;
        
        if(![fileManager fileExistsAtPath:m_cacheDirectory]) {
            NSError *error;
            
            [fileManager createDirectoryAtPath:m_cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        }
        
        enumerator = [fileManager enumeratorAtPath:m_cacheDirectory];
        
        while((path = [enumerator nextObject]) != nil) {
            MFWebCache_Resource *resource = [[MFWebCache_Resource alloc] init];
            
            resource->m_resource = [[MFWebResource alloc] initWithCache:self path:[m_cacheDirectory stringByAppendingPathComponent:path]];
            
            if(resource->m_resource) {
                [m_resources setObject:resource forKey:resource->m_resource.URL];
            }
        }
    }
    
    return self;
}

- (NSArray *)availableResources
{
    return m_resources.allKeys;
}

- (MFWebResource *)resourceForURL:(NSURL *)URL
{
    if(URL) {
        MFWebCache_Resource *resource = [m_resources objectForKey:URL.absoluteURL];
        
        if(resource && resource->m_resource) {
            resource->m_markedForDeletion = NO;
            resource->m_usageCount += 1;
            
            return [resource->m_resource copy];
        }
    }
    
    return nil;
}

- (void)markObsoleteResources
{
    NSMutableArray *resources = [NSMutableArray array];
    NSInteger cacheSize = 0;
    
    // Search for unused resources
    for(NSURL *url in m_resources.keyEnumerator) {
        MFWebCache_Resource *resource = [m_resources objectForKey:url];
        
        if(!resource->m_markedForDeletion && resource->m_usageCount == 0 && resource->m_resource) {
            [resources addObject:resource->m_resource];
            cacheSize += resource->m_resource.fileSize;
        }
    }
    
    // Delete older resources if the cache limit is exceeded
    if(cacheSize >= m_cacheSize) {
        [resources sortUsingSelector:@selector(compare:)];
        cacheSize = 0;
        
        for(NSInteger i = 0, c = resources.count; i < c; i++) {
            MFWebResource *resource = [resources objectAtIndex:i];
            
            cacheSize += resource.fileSize;
            
            if(cacheSize >= m_cacheSize) {
                while(i < c) {
                    MFWebCache_Resource *r = [m_resources objectForKey:((MFWebResource *)[resources objectAtIndex:i]).URL.absoluteURL];
                    
                    if(r) {
                        r->m_markedForDeletion = YES;
                    }
                    
                    i++;
                }
                
                break;
            }
        }
    }
}

- (void)invalidateObsoleteResources
{
    NSMutableSet *resourcesToRemove = nil;
    
    for(NSURL *url in m_resources.keyEnumerator) {
        MFWebCache_Resource *resource = [m_resources objectForKey:url];
        
        if(resource->m_markedForDeletion && resource->m_usageCount == 0) {
            if(!resourcesToRemove) {
                resourcesToRemove = [NSMutableSet set];
            }
            
            [resourcesToRemove addObject:url];
        }
    }
    
    if(resourcesToRemove.count > 0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        for(NSURL *url in resourcesToRemove) {
            MFWebCache_Resource *resource = [m_resources objectForKey:url];
            
            if(resource->m_resource) {
                NSError *error;
                
                [fileManager removeItemAtURL:[NSURL fileURLWithPath:resource->m_resource.filePath] error:&error];
                MFLog(@"%@: Deleted cached resource (%@)", self.class, url.absoluteString);
            }
            
            [m_resources removeObjectForKey:url];
        }
    }
}

- (void)removeResourceForURL:(NSURL *)URL
{
    MFWebCache_Resource *resource = [m_resources objectForKey:URL.absoluteURL];
    
    if(resource) {
        resource->m_markedForDeletion = YES;
        [self invalidateObsoleteResources];
    }
}

- (void)invalidateResourceForURL:(NSURL *)URL
{
    MFWebCache_Resource *resource = [m_resources objectForKey:URL.absoluteURL];
    
    if(resource) {
        resource->m_usageCount -= 1;
        [self markObsoleteResources];
        [self invalidateObsoleteResources];
    }
}

- (void)requestResource:(NSURL *)url target:(id)target usingBlock:(MFWebCacheBlock)block
{
    MFWebCache_Resource *resource = [m_resources objectForKey:url.absoluteURL];
    
    if(resource) {
        // Avoid duplicates
        for(MFWebCache_Request *request in resource->m_requests) {
            if(request.target == target) {
                return;
            }
        }
        
        resource->m_markedForDeletion = NO;
        resource->m_usageCount += 1;
        
        if(resource->m_resource) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(target, nil, [resource->m_resource copy]);
            });
        } else {
            MFWebCache_Request *request = [[MFWebCache_Request alloc] initWithService:m_service mode:kMFWebRequestModeGet target:target URL:url parameters:nil sign:NO];
            
            if(!resource->m_requests) {
                resource->m_requests = [NSMutableArray array];
            }
            
            request.block = block;
            [resource->m_requests addObject:request];
        }
    } else {
        MFWebCache_Request *request = [[MFWebCache_Request alloc] initWithService:m_service mode:kMFWebRequestModeGet target:target URL:url parameters:nil sign:NO];
        NSString *path = [m_cacheDirectory stringByAppendingPathComponent:[url.absoluteString dataUsingEncoding:NSUTF8StringEncoding].base64SafeString];
        
        request.block = block;
        
        resource = [[MFWebCache_Resource alloc] init];
        resource->m_usageCount = 1;
        resource->m_requests = [NSMutableArray array];
        [resource->m_requests addObject:request];
        [m_resources setObject:resource forKey:url.absoluteURL];
        
        request = [[MFWebCache_Request alloc] initWithService:m_service mode:kMFWebRequestModeGet target:resource URL:url parameters:nil sign:NO];
        request.downloadDestinationPath = path;
        request.block = ^(id target, NSError *error, id result) {
            NSArray *requests = resource->m_requests;
            
            resource->m_requests = nil;
            
            if(!error) {
                resource->m_resource = [[MFWebResource alloc] initWithCache:self path:path];
                
                if(!resource->m_resource) {
                    error = [NSError errorWithDomain:MFWebServiceErrorDomain code:kMFWebServiceErrorInternalData userInfo:nil];
                }
            }
            
            if(error) {
                resource->m_markedForDeletion = YES;
                resource->m_usageCount = 0;
                
                for(MFWebCache_Request *request in requests) {
                    request.block(request.target, error, nil);
                }
                
                [self invalidateObsoleteResources];
            } else {
                MFLog(@"%@: Cached resource (%@)", self.class, url.absoluteString);
                
                for(MFWebCache_Request *request in requests) {
                    request.block(request.target, nil, [resource->m_resource copy]);
                }
            }
        };
        
        [m_service addRequest:request];
    }
}

- (void)cancelResourcesForTarget:(id)target
{
    [m_service cancelRequestsForTarget:target waitUntilFinished:NO];
    
    for(NSURL *url in m_resources.keyEnumerator) {
        MFWebCache_Resource *resource = [m_resources objectForKey:url];
        
        for(NSInteger i = 0, c = resource->m_requests.count; i < c; i++) {
            MFWebCache_Request *request = [resource->m_requests objectAtIndex:i];
            
            if(request.target == target) {
                [resource->m_requests removeObjectAtIndex:i];
                i--;
                c--;
            }
        }
    }
}

- (void)cancelAllResources
{
    for(NSURL *url in m_resources.keyEnumerator) {
        MFWebCache_Resource *resource = [m_resources objectForKey:url];
        
        if(resource->m_requests.count > 0) {
            NSMutableArray *requests = resource->m_requests;
            
            resource->m_requests = nil;
            resource->m_markedForDeletion = YES;
            resource->m_usageCount = 0;
            
            for(MFWebCache_Request *request in requests) {
                [request cancel];
            }
        }
    }
}

@end
