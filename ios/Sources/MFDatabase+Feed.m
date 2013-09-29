/* Copyright (c) 2013 Meep Factory OU */

#import "JSONKit.h"
#import "MFDatabase+Feed.h"
#import "MFDatabaseProxy.h"
#import "MFFeed.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangeFeedsNotification = @"MFDatabaseDidChangeFeeds";

#define FEED_BOOKMARKS @"bookmarks"
#define TABLE_FEED @"feeds"

@interface MFDatabaseProxy_Feed : MFDatabaseProxy

@end

@implementation MFDatabaseProxy_Feed

#pragma mark MFDatabaseProxy

- (void)invalidateObjects
{
    NSMutableSet *feeds = [[NSMutableSet alloc] init];
    
    [m_database.store invalidateObjectsInTable:TABLE_FEED usingBlock:^(NSString *table, NSString *key) {
        [feeds addObject:key];
    }];
    
    if(feeds.count > 0) {
        [m_database addUpdate:MFDatabaseDidChangeFeedsNotification changes:feeds];
    }
}

@end

#pragma mark -

@implementation MFDatabase(Feed)

- (void)attach_proxy_feeds
{
    [self.store setObjectUnlessExists:[[NSDictionary dictionary] JSONData] forKey:FEED_BOOKMARKS inTable:TABLE_FEED];
    [m_proxies addObject:[[MFDatabaseProxy_Feed alloc] initWithDatabase:self]];
}

- (MFFeed *)feedForIdentifier:(NSString *)identifier ttl:(NSTimeInterval *)ttl
{
    return nil;
}

- (void)setFeed:(MFFeed *)feed forIdentifier:(NSString *)identifier ttl:(NSTimeInterval *)ttl
{
}

- (NSArray *)postsForFeed:(NSString *)identifier
{
    return nil;
}

- (void)setPosts:(NSArray *)posts forFeed:(NSString *)identifier
{
}

- (void)addPosts:(NSArray *)posts forFeed:(NSString *)identifier
{
}

@end
