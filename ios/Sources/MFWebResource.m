/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebCache.h"
#import "MFWebResource.h"
#import "MFWebServiceError.h"
#import "NSData+Additions.h"
#import <sys/stat.h>
#import <unistd.h>

@interface MFWebCache(Resources)

- (void)invalidateResourceForURL:(NSURL *)url;

@end

#pragma mark -

@interface MFWebResource_Error : MFWebResource
{
    @private
    NSError *m_error;
}

- (id)initWithError:(NSError *)error;

@end

@implementation MFWebResource_Error

- (id)initWithError:(NSError *)error
{
    self = [super init];
    
    if(self) {
        m_error = error;
    }
    
    return self;
}

#pragma mark MFWebResource

- (NSError *)error
{
    return m_error;
}

@end

#pragma mark -

@implementation MFWebResource

+ (MFWebResource *)errorResource
{
    __strong static MFWebResource *errorResource = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        errorResource = [[MFWebResource_Error alloc] initWithError:[NSError errorWithDomain:MFWebServiceErrorDomain code:kMFWebServiceErrorInternalData userInfo:nil]];
    });
    
    return errorResource;
}

+ (MFWebResource *)nullResource
{
    __strong static MFWebResource *nullResource = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        nullResource = [[MFWebResource alloc] init];
    });
    
    return nullResource;
}

- (id)initWithCache:(MFWebCache *)cache path:(NSString *)filePath
{
    self = [super init];
    
    if(self) {
        NSData *data = [[NSData alloc] initWithBase64SafeString:filePath.lastPathComponent];
        struct stat s;
		
        if(data) {
            NSString *urlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            m_URL = (urlString) ? [[NSURL alloc] initWithString:urlString] : nil;
        }
        
		if(stat(filePath.fileSystemRepresentation, &s) == 0) {
            m_filePath = filePath;
			m_fileSize = (NSInteger)s.st_size;
            m_timestamp = s.st_atimespec.tv_sec;
		}
        
        if(!m_URL || !m_filePath) {
            return nil;
        }
    }
    
    return self;
}

@dynamic error;

- (NSError *)error
{
    return nil;
}

@synthesize filePath = m_filePath;
@synthesize fileSize = m_fileSize;
@synthesize timestamp = m_timestamp;
@synthesize URL = m_URL;

- (NSComparisonResult)compare:(MFWebResource *)resource
{
    if(resource != nil && resource != self) {
        if(self->m_timestamp > resource->m_timestamp) {
            return NSOrderedAscending;
        }
        
        if(self->m_timestamp < resource->m_timestamp) {
            return NSOrderedDescending;
        }
    }
    
    return NSOrderedSame;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    MFWebResource *copy = [[self.class alloc] init];
    
    if(copy) {
        copy->m_filePath = m_filePath;
        copy->m_fileSize = m_fileSize;
        copy->m_timestamp = m_timestamp;
        copy->m_URL = m_URL;
        copy->m_cache = m_cache;
    }
    
    return copy;
}

#pragma mark NSObject

- (void)dealloc
{
    if(m_URL && m_cache) {
        [m_cache invalidateResourceForURL:m_URL];
    }
}

@end
