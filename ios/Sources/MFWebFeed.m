/* Copyright (c) 2013 Meep Factory OU */

#import "MFColor.h"
#import "MFDatabase.h"
#import "MFDatabase+Brand.h"
#import "MFDatabase+Bookmark.h"
#import "MFDatabase+Color.h"
#import "MFDatabase+Country.h"
#import "MFDatabase+Currency.h"
#import "MFDatabase+Delivery.h"
#import "MFDatabase+Event.h"
#import "MFDatabase+Feed.h"
#import "MFDatabase+Post.h"
#import "MFDatabase+Recents.h"
#import "MFDatabase+Size.h"
#import "MFDatabase+State.h"
#import "MFDatabase+Type.h"
#import "MFDelta.h"
#import "MFFeed.h"
#import "MFPost.h"
#import "MFSize.h"
#import "MFType.h"
#import "MFWebFeed.h"
#import "MFWebService.h"
#import "MFWebService+Feed.h"
#import "NSArray+Additions.h"
#import "NSDictionary+Additions.h"

NSString *MFWebFeedChangesKey = @"changes";
NSString *MFWebFeedErrorKey = @"error";

NSString *MFWebFeedDidBeginLoadingNotification = @"MFWebFeedDidBeginLoading";
NSString *MFWebFeedDidEndLoadingNotification = @"MFWebFeedDidEndLoading";
NSString *MFWebFeedDidChangeNotification = @"MFWebFeedDidChange";

#define FEED_ALL @"all"
#define FEED_ONLY_NEW @"only_new"
#define FEED_ONLY_EDITORIAL @"only_editorial"
#define FEED_BOOKMARKS @"bookmarks"
#define FEED_HISTORY @"history"
#define FEED_RECENTS @"recents"
#define FEED_FEATURED @"featured"

#define LOADING_DELAY 0.3
#define LOADING_LIMIT 2

static inline NSDictionary *MFWebFeedGetUserInfo(NSArray *changes, NSError *error) {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    
    [userInfo setValue:error forKey:MFWebFeedErrorKey];
    [userInfo setValue:changes forKey:MFWebFeedChangesKey];
    
    return userInfo;
}

#pragma mark -

@implementation MFWebFeed

+ (NSMutableDictionary *)sharedFeeds
{
    __strong static NSMutableDictionary *sharedFeeds = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        sharedFeeds = [[NSMutableDictionary alloc] init];
    });
    
    return sharedFeeds;
}

+ (NSString *)resolveIdentifier:(NSString *)identifier filters:(NSArray *)filters
{
    if(filters.count > 0) {
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        NSMutableArray *sizes = [[NSMutableArray alloc] init];
        NSMutableArray *types = [[NSMutableArray alloc] init];
        NSMutableArray *tags = [[NSMutableArray alloc] init];
        
        for(id filter in filters) {
            if([filter isKindOfClass:[MFType class]]) {
                NSString *identifier = ((MFType *)filter).identifier;
                
                if(identifier) {
                    [types addObject:identifier];
                }
            } else if([filter isKindOfClass:[MFColor class]]) {
                NSString *identifier = ((MFColor *)filter).identifier;
                
                if(identifier) {
                    [colors addObject:identifier];
                }
            } else if([filter isKindOfClass:[MFSize class]]) {
                NSString *identifier = ((MFSize *)filter).identifier;
                
                if(identifier) {
                    [sizes addObject:identifier];
                }
            } else if([filter isKindOfClass:[NSString class]]) {
                [tags addObject:[filter stringByReplacingOccurrencesOfString:@"+" withString:@","]];
            }
        }
        
        if(colors.count > 0) {
            identifier = [identifier stringByAppendingFormat:@"+color,%@", [colors componentsJoinedByString:@","]];
        }
        
        if(types.count > 0) {
            identifier = [identifier stringByAppendingFormat:@"+type,%@", [types componentsJoinedByString:@","]];
        }
        
        if(sizes.count > 0) {
            identifier = [identifier stringByAppendingFormat:@"+size,%@", [sizes componentsJoinedByString:@","]];
        }
        
        if(tags.count > 0) {
            identifier = [identifier stringByAppendingFormat:@"+tag,%@", [tags componentsJoinedByString:@","]];
        }
    }
    
    return identifier;
}

+ (MFWebFeed *)sharedFeedWithIdentifier:(NSString *)identifier filters:(NSArray *)filters
{
    NSMutableDictionary *feeds = [self sharedFeeds];
    MFWebFeed *feed;
    
    identifier = [self resolveIdentifier:identifier filters:filters];
    feed = [feeds objectForKey:identifier];
    
    if(!feed) {
        feed = [[MFWebFeed alloc] initWithIdentifier:identifier];
        [feeds setObject:feed forKey:identifier];
    }
    
    return feed;
}

+ (MFWebFeed *)sharedBookmarksFeed
{
    __strong static MFWebFeed *sharedBookmarksFeed = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        sharedBookmarksFeed = [[self alloc] initWithIdentifier:FEED_BOOKMARKS];
    });
    
    return sharedBookmarksFeed;
}

+ (MFWebFeed *)sharedFeaturedFeed
{
    __strong static MFWebFeed *sharedFeaturedFeed = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        sharedFeaturedFeed = [[self alloc] initWithIdentifier:FEED_FEATURED];
    });
    
    return sharedFeaturedFeed;
}

+ (MFWebFeed *)sharedHistoryFeed
{
    __strong static MFWebFeed *sharedHistoryFeed = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        sharedHistoryFeed = [[self alloc] initWithIdentifier:FEED_HISTORY];
    });
    
    return sharedHistoryFeed;
}

+ (MFWebFeed *)sharedRecentsFeed
{
    __strong static MFWebFeed *sharedRecentsFeed = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        sharedRecentsFeed = [[self alloc] initWithIdentifier:FEED_RECENTS];
    });
    
    return sharedRecentsFeed;
}

+ (MFWebFeed *)sharedFeed
{
    return [self sharedFeedOfKind:kMFWebFeedKindFeatured];
}

+ (MFWebFeed *)sharedFeedOfKind:(MFWebFeedKind)kind
{
    return [self sharedFeedOfKind:kind filters:nil];
}

+ (MFWebFeed *)sharedFeedOfKind:(MFWebFeedKind)kind filters:(NSArray *)filters
{
    switch(kind) {
        case kMFWebFeedKindAll:
            return [self sharedFeedWithIdentifier:FEED_ALL filters:nil];
        case kMFWebFeedKindOnlyNew:
            return [self sharedFeedWithIdentifier:FEED_ONLY_NEW filters:nil];
        case kMFWebFeedKindOnlyEditorial:
            return [self sharedFeedWithIdentifier:FEED_ONLY_EDITORIAL filters:nil];
        case kMFWebFeedKindBookmarks:
            return [self sharedBookmarksFeed];
        case kMFWebFeedKindFeatured:
            return [self sharedFeaturedFeed];
        case kMFWebFeedKindHistory:
            return [self sharedHistoryFeed];
        case kMFWebFeedKindRecents:
            return [self sharedRecentsFeed];
        default:
            break;
    }
    
    return nil;
}

- (void)beginEditing
{
    m_editing += 1;
}

- (void)endEditing
{
    m_editing -= 1;
}

- (NSArray *)fetchPosts
{
    MFDatabase *database = [MFDatabase sharedDatabase];
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    
    for(MFPost *post in [database postsForFeed:m_identifier]) {
        if(post.active) {
            [posts addObject:post];
        }
    }
    
    if([m_identifier isEqualToString:FEED_BOOKMARKS]) {
        [posts sortUsingComparator:^NSComparisonResult (MFPost *post1, MFPost *post2) {
            return [post1.title compare:post2.title];
        }];
        
        if(m_feed.offset != posts.count) {
            m_feed = [[MFFeed alloc] initWithFeed:m_feed offset:posts.count];
        }
    } else if(![m_identifier isEqualToString:FEED_RECENTS]) {
        [posts sortUsingComparator:^NSComparisonResult (MFPost *post1, MFPost *post2) {
            NSDate *date1 = post1.date;
            NSDate *date2 = post2.date;
            NSComparisonResult r = (date1 && date2) ? [date2 compare:date1] : NSOrderedSame;
            
            if(r == NSOrderedSame) {
                long long id1 = post1.identifier.longLongValue;
                long long id2 = post2.identifier.longLongValue;
                
                if(id1 > id2) {
                    r = NSOrderedAscending;
                } else if(id1 < id2) {
                    r = NSOrderedDescending;
                }
            }
            
            return r;
        }];
    }
    
    return posts;
}

- (void)loadState
{
    if(m_identifier) {
        MFDatabase *database = [MFDatabase sharedDatabase];
        
        [self beginEditing];
        
        m_feed = [database feedForIdentifier:m_identifier ttl:&m_ttl];
        
        if(!m_feed) {
            m_feed = [[MFFeed alloc] init];
            [database setFeed:m_feed forIdentifier:m_identifier ttl:&m_ttl];
        }
        
        m_posts = [self fetchPosts];
        
        if(m_feed.offset > m_posts.count) {
            MFError(@"Inconsistent internal db (%d > %d", m_feed.offset, m_posts.count);
            m_feed = [[MFFeed alloc] initWithState:m_feed.state cursor:m_feed.cursor offset:m_posts.count];
        }
        
        [self endEditing];
    }
}

- (void)saveState
{
    if(m_identifier) {
        MFDatabase *database = [MFDatabase sharedDatabase];
        
        [self beginEditing];
        
        [database setFeed:m_feed forIdentifier:m_identifier ttl:&m_ttl];
        
        [self endEditing];
    }
}

- (BOOL)clearState
{
    BOOL changed = (m_posts.count > 0) ? YES : NO;
    
    if(m_identifier) {
        MFDatabase *database = [MFDatabase sharedDatabase];
        
        [self beginEditing];
        
        m_feed = [[MFFeed alloc] init];
        [database setFeed:m_feed forIdentifier:m_identifier ttl:&m_ttl];
        m_posts = [[NSMutableArray alloc] init];
        
        [self endEditing];
    }
    
    return changed;
}

- (NSArray *)mergeState:(MFFeed *)feed expand:(NSInteger)expand
{
    MFDatabase *database = [MFDatabase sharedDatabase];
    NSArray *filteredPosts1 = m_posts;
    NSInteger locationMarker = m_feed.offset;
    NSArray *filteredPosts2 = filteredPosts1;
    NSMutableSet *changes = nil;
    NSArray *delta = nil;
    BOOL changed = NO;
    BOOL cposts = NO;
    
    [self beginEditing];
    [database beginUpdates];
    
    if(feed) {
        if(feed.currencies && !MFEqual(database.currencies, feed.currencies)) {
            database.currencies = feed.currencies;
            changed = YES;
        }
        
        if(feed.brands && !MFEqual(database.brands, feed.brands)) {
            database.brands = feed.brands;
            changed = YES;
        }
        
        if(feed.colors && !MFEqual(database.colors, feed.colors)) {
            database.colors = feed.colors;
            changed = YES;
        }
        
        if(feed.countries && !MFEqual(database.countries, feed.countries)) {
            database.countries = feed.countries;
            changed = YES;
        }
        
        if(feed.deliveries && !MFEqual(database.deliveries, feed.deliveries)) {
            database.deliveries = feed.deliveries;
            changed = YES;
        }
        
        if(feed.events.count > 0) {
            [database addEvents:feed.events];
            changed = YES;
        }
        
        if(feed.sizes && !MFEqual(database.sizes, feed.sizes)) {
            database.sizes = feed.sizes;
            changed = YES;
        }
        
        if(feed.types && !MFEqual(database.types, feed.types)) {
            database.types = feed.types;
            changed = YES;
        }
        
        if(!MFEqual(m_feed.state, feed.state) || m_feed.cursor != feed.cursor) {
            m_feed = [[MFFeed alloc] initWithFeed:feed offset:m_feed.offset];
            changed = YES;
        }
        
        if(feed.prefix && ![database.globalPrefix isEqual:feed.prefix]) {
            database.globalPrefix = feed.prefix;
            changed = YES;
        }
        
        if(feed.globals && ![database.globalState isEqualToString:feed.globals]) {
            database.globalState = feed.globals;
            changed = YES;
        }
        
        if(feed.posts.count > 0) {
            for(MFPost *post in feed.posts) {
                [database setPost:post forIdentifier:post.identifier];
            }
            
            [database addPosts:feed.posts forFeed:m_identifier];
            changed = YES;
            cposts = YES;
        }
        
        if(feed.changes.count > 0) {
            NSMutableDictionary *map = [NSMutableDictionary dictionary];
            
            changes = [[NSMutableSet alloc] init];
            
            for(MFPost *post in m_posts) {
                [map setObject:post forKey:post.identifier];
            }
            
            for(NSDictionary *change in feed.changes) {
                NSString *identifier = [change identifierForKey:@"id"];
                MFPost *post = (identifier) ? [map objectForKey:identifier] : nil;
                
                if(!post && identifier) {
                    MFError(@"Inconsistent internal db (p=%@)", identifier);
                    post = [database postForIdentifier:identifier];
                }
                
                if([post update:change]) {
                    [changes addObject:post];
                    changed = YES;
                    cposts = YES;
                }
            }
            
            for(MFPost *change in changes) {
                [database setPost:change forIdentifier:change.identifier];
            }
        }
    }
    
    if(cposts) {
        m_posts = [self fetchPosts];
        filteredPosts2 = m_posts;
    }
    
    if(filteredPosts1 != filteredPosts2 || expand > 0) {
        NSInteger offset = m_feed.offset;
        MFPost *last = nil;
        
        for(NSInteger i = offset; i > 0; i--) {
            MFPost *test = [filteredPosts1 objectAtIndex:i - 1];
            
            if([filteredPosts2 indexOfObject:test] != NSNotFound) {
                last = test;
                break;
            }
        }
        
        if(last) {
            NSInteger lastIndex1 = offset;
            NSInteger lastIndex2 = [filteredPosts2 indexOfObject:last] + 1;
            
            offset = (lastIndex1 > lastIndex2) ? lastIndex1 : lastIndex2;
        } else if(expand > 0) {
            offset = 0;
        } else {
            offset = LOADING_LIMIT;
        }
        
        if(expand > 0) {
            offset += expand;
        }
        
        if(offset > filteredPosts2.count) {
            offset = filteredPosts2.count;
        }
        
        if(m_feed.offset != offset) {
            m_feed = [[MFFeed alloc] initWithFeed:m_feed offset:offset];
            changed = YES;
        }
        
        delta = [[filteredPosts1 subarrayWithRange:NSMakeRange(0, locationMarker)] deltaWithArray:[filteredPosts2 subarrayWithRange:NSMakeRange(0, offset)]
                                                                                          changes:changes];
    }
    
    if(changed || locationMarker != m_feed.offset) {
        [self saveState];
    }
    
    [database endUpdates];
    [self endEditing];
    
    return delta;
}

- (id)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    
    if(self) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
        m_identifier = identifier;
        [self loadState];
        
        if([identifier isEqualToString:FEED_BOOKMARKS]) {
            [notificationCenter addObserver:self selector:@selector(databaseBookmarksDidChange:) name:MFDatabaseDidChangeBookmarksNotification object:[MFDatabase sharedDatabase]];
        } else if([identifier isEqualToString:FEED_RECENTS]) {
            [notificationCenter addObserver:self selector:@selector(databaseRecentsDidChange:) name:MFDatabaseDidChangeRecentsNotification object:[MFDatabase sharedDatabase]];
        } else {
            [notificationCenter addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
            [notificationCenter addObserver:self selector:@selector(databaseFeedsDidChange:) name:MFDatabaseDidChangeFeedsNotification object:[MFDatabase sharedDatabase]];
        }
        
        [notificationCenter addObserver:self selector:@selector(databasePostsDidChange:) name:MFDatabaseDidChangePostsNotification object:[MFDatabase sharedDatabase]];
    }
    
    return self;
}

- (id)initWithFilters:(NSArray *)filters
{
    return [self initWithIdentifier:[self.class resolveIdentifier:FEED_ALL filters:filters]];
}

@synthesize identifier = m_identifier;

@dynamic local;

- (BOOL)isLocal
{
    return ([m_identifier isEqualToString:FEED_BOOKMARKS] || [m_identifier isEqualToString:FEED_RECENTS]) ? YES : NO;
}

@dynamic atEnd;

- (BOOL)isAtEnd
{
    return (m_feed.cursor == kMFFeedCursorEnd && m_feed.offset >= m_posts.count) ? YES : NO;
}

@dynamic posts;

- (NSArray *)posts
{
    return (self.local) ? m_posts : [m_posts subarrayWithRange:NSMakeRange(0, m_feed.offset)];
}

@dynamic numberOfResults;

- (NSInteger)numberOfResults
{
    return m_feed.count;
}

@dynamic kind;

- (MFWebFeedKind)kind
{
    if([m_identifier isEqualToString:FEED_ALL]) {
        return kMFWebFeedKindAll;
    }
    
    if([m_identifier isEqualToString:FEED_ONLY_NEW]) {
        return kMFWebFeedKindOnlyNew;
    }
    
    if([m_identifier isEqualToString:FEED_ONLY_EDITORIAL]) {
        return kMFWebFeedKindOnlyEditorial;
    }
    
    if([m_identifier isEqualToString:FEED_BOOKMARKS]) {
        return kMFWebFeedKindBookmarks;
    }
    
    if([m_identifier isEqualToString:FEED_FEATURED]) {
        return kMFWebFeedKindFeatured;
    }
    
    if([m_identifier isEqualToString:FEED_HISTORY]) {
        return kMFWebFeedKindHistory;
    }
    
    if([m_identifier isEqualToString:FEED_RECENTS]) {
        return kMFWebFeedKindRecents;
    }
    
    return kMFWebFeedKindUnknown;
}

@dynamic loading;

- (BOOL)isLoading
{
    return (m_loadingBackward || m_loadingForward) ? YES : NO;
}

@synthesize loadingBackward = m_loadingBackward;
@synthesize loadingForward = m_loadingForward;

- (void)loadForward
{
    if(!m_identifier && !m_loadingBackward) {
        m_loadingForward = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidBeginLoadingNotification object:self userInfo:nil];
        
        [[MFWebService sharedService] requestGlobals:[MFDatabase sharedDatabase].globalState target:self usingBlock:^(id target, NSError *error, MFFeed *feed) {
            if(feed) {
                NSArray *changes = nil;
                
                [self beginEditing];
                
                if((changes = [self mergeState:feed expand:0]) != nil) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidChangeNotification object:self userInfo:MFWebFeedGetUserInfo(nil, nil)];
                }
                
                [self endEditing];
            }
            
            m_loadingForward = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidEndLoadingNotification object:self userInfo:MFWebFeedGetUserInfo(nil, error)];
        }];
    } else if(!m_loadingForward && !self.local) {
        NSString *state = m_feed.state;
        
        m_loadingForward = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidBeginLoadingNotification object:self userInfo:nil];
        
        [[MFWebService sharedService] requestFeed:m_identifier forward:YES limit:LOADING_LIMIT state:state globals:[MFDatabase sharedDatabase].globalState target:self usingBlock:^(id target, NSError *error, MFFeed *feed) {
            if(feed) {
                NSArray *changes = nil;
                BOOL didChange = NO;
                
                [self beginEditing];
                
                if(!state) {
                    didChange = [self clearState];
                }
                
                if((changes = [self mergeState:feed expand:0]) != nil || didChange) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidChangeNotification object:self userInfo:MFWebFeedGetUserInfo((state) ? changes : nil, nil)];
                }
                
                [self endEditing];
            }
            
            m_loadingForward = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidEndLoadingNotification object:self userInfo:MFWebFeedGetUserInfo(nil, error)];
        }];
    }
}

- (void)loadBackward
{
    if(m_identifier && !m_loadingBackward && ![m_identifier isEqualToString:FEED_BOOKMARKS]) {
        m_loadingBackward = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidBeginLoadingNotification object:self userInfo:nil];
        
        if((m_feed.offset + LOADING_LIMIT < m_posts.count) || (m_feed.offset < m_posts.count && m_feed.cursor == kMFFeedCursorEnd)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LOADING_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *changes = [self mergeState:nil expand:LOADING_LIMIT];
                
                if(changes.count > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidChangeNotification object:self userInfo:MFWebFeedGetUserInfo(changes, nil)];
                }
                
                m_loadingBackward = NO;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidEndLoadingNotification object:self userInfo:MFWebFeedGetUserInfo(nil, nil)];
            });
        } else {
            NSString *state = m_feed.state;
            
            [[MFWebService sharedService] requestFeed:m_identifier forward:NO limit:LOADING_LIMIT state:state globals:[MFDatabase sharedDatabase].globalState target:self usingBlock:^(id target, NSError *error, MFFeed *feed) {
                if(feed && MFEqual(m_feed.state, state)) {
                    NSArray *changes = [self mergeState:feed expand:LOADING_LIMIT];
                    
                    if(changes.count > 0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidChangeNotification object:self userInfo:MFWebFeedGetUserInfo(changes, nil)];
                    }
                }
                
                m_loadingBackward = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidEndLoadingNotification object:self userInfo:MFWebFeedGetUserInfo(nil, error)];
            }];
        }
    }
}

- (void)reloadData
{
    if(!self.local) {
        [[MFWebService sharedService] cancelRequestsForTarget:self];
        
        m_loadingBackward = NO;
        m_loadingForward = NO;
        
        if([self clearState]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidChangeNotification object:self];
        }
        
        [self loadForward];
    } else {
        [self loadState];
    }
}

- (void)invalidateData
{
    if(!self.local) {
        NSTimeInterval delta = fabs(m_ttl - [NSDate timeIntervalSinceReferenceDate]);
        
        if(delta > 30.0F * 60.0F) { // 30 minutes
            [self loadForward];
        }
    } else {
        [self loadState];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self invalidateData];
}

- (void)databaseFeedsDidChange:(NSNotification *)notification
{
    if(m_editing == 0) {
        NSSet *changes = [notification.userInfo objectForKey:MFDatabaseChangesKey];
        
        if(!changes || [changes containsObject:self.identifier]) {
            [self reloadData];
        }
    }
}

- (void)databaseRecentsDidChange:(NSNotification *)notification
{
    if(m_editing == 0) {
        NSArray *posts = [self fetchPosts];
        
        if(!MFEqual(m_posts, posts)) {
            m_posts = posts;
            [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidChangeNotification object:self];
        }
    }
}

- (void)databaseBookmarksDidChange:(NSNotification *)notification
{
    if(m_editing == 0) {
        NSArray *posts = [self fetchPosts];
        
        if(!MFEqual(m_posts, posts)) {
            m_posts = posts;
            [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidChangeNotification object:self];
        }
    }
}

- (void)databasePostsDidChange:(NSNotification *)notification
{
    if(m_editing == 0) {
        NSSet *changes = [notification.userInfo objectForKey:MFDatabaseChangesKey];
        BOOL changed = NO;
        
        if(changes) {
            for(MFPost *post in m_posts) {
                if([changes containsObject:post.identifier]) {
                    changed = YES;
                    break;
                }
            }
        } else {
            changed = YES;
        }
        
        if(changed) {
            NSArray *posts = [self fetchPosts];
            
            if(!MFEqual(m_posts, posts)) {
                m_posts = posts;
                [[NSNotificationCenter defaultCenter] postNotificationName:MFWebFeedDidChangeNotification object:self];
            }
        }
    }
}

#pragma mark NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
