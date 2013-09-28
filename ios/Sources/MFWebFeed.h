/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

typedef enum _MFWebFeedKind {
    kMFWebFeedKindAll = 0,
    kMFWebFeedKindOnlyNew,
    kMFWebFeedKindOnlyEditorial = 0
} MFWebFeedKind;

@interface MFWebFeed : NSObject
{
    @private
}

+ (MFWebFeed *)sharedFeedOfKind:(MFWebFeedKind)kind;

@end
