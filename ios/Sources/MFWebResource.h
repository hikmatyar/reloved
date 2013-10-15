/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFWebCache;

@interface MFWebResource : NSObject <NSCopying>
{
    @private
    __unsafe_unretained MFWebCache *m_cache;
    NSString *m_filePath;
    NSInteger m_fileSize;
    NSTimeInterval m_timestamp;
    NSURL *m_URL;
}

+ (MFWebResource *)errorResource;
+ (MFWebResource *)nullResource;

- (id)initWithCache:(MFWebCache *)cache path:(NSString *)filePath;

@property (nonatomic, retain, readonly) NSError *error;
@property (nonatomic, retain, readonly) NSString *filePath;
@property (nonatomic, assign, readonly) NSInteger fileSize;
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;
@property (nonatomic, retain, readonly) NSURL *URL;

@end
