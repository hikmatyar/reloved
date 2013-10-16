/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

typedef enum _MFMediaSize {
    kMFMediaSizeOriginal = 0,
    kMFMediaSizeThumbnailSmall,
    kMFMediaSizeThumbnailLarge,
    kMFMediaSizePhoto
} MFMediaSize;

@interface MFDatabase(State)

@property (nonatomic, retain) NSString *globalState;
@property (nonatomic, retain) NSURL *globalPrefix;

- (NSURL *)URLForMedia:(NSString *)mediaId size:(MFMediaSize)size;
- (NSURL *)URLForString:(NSString *)str;

@end
