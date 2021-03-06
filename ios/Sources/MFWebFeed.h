/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

typedef enum _MFWebFeedKind {
    kMFWebFeedKindUnknown = 0,
    kMFWebFeedKindAll,
    kMFWebFeedKindOnlyNew,
    kMFWebFeedKindOnlyEditorial,
    kMFWebFeedKindBookmarks,
    kMFWebFeedKindCart,
    kMFWebFeedKindFeatured,
    kMFWebFeedKindRecents,
    kMFWebFeedKindHistory
} MFWebFeedKind;

extern NSString *MFWebFeedOldPostsKey;
extern NSString *MFWebFeedChangesKey;
extern NSString *MFWebFeedErrorKey;

extern NSString *MFWebFeedDidBeginLoadingNotification;
extern NSString *MFWebFeedDidEndLoadingNotification;
extern NSString *MFWebFeedDidChangeNotification;

@class MFFeed;

@interface MFWebFeed : NSObject
{
    @private
    NSString *m_identifier;
    MFFeed *m_feed;
    MFWebFeedKind m_kind;
    BOOL m_loadingForward;
    BOOL m_loadingBackward;
    NSArray *m_posts;
    NSInteger m_editing;
    NSTimeInterval m_ttl;
}

+ (MFWebFeed *)sharedFeed;
+ (MFWebFeed *)sharedFeedOfKind:(MFWebFeedKind)kind;
+ (MFWebFeed *)sharedFeedOfKind:(MFWebFeedKind)kind filters:(NSArray *)filters cache:(BOOL)cache;

- (id)initWithIdentifier:(NSString *)identifier;
- (id)initWithFilters:(NSArray *)filters;

@property (nonatomic, assign, readonly, getter = isLocal) BOOL local;
@property (nonatomic, assign, readonly, getter = isAtEnd) BOOL atEnd;
@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, assign, readonly, getter = isLoadingForward) BOOL loadingForward;
@property (nonatomic, assign, readonly, getter = isLoadingBackward) BOOL loadingBackward;

@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, assign, readonly) MFWebFeedKind kind;
@property (nonatomic, retain, readonly) NSArray *posts;
@property (nonatomic, assign, readonly) NSInteger numberOfResults;

- (void)loadForward;
- (void)loadBackward;
- (void)reloadData;
- (void)invalidateData;

@end
