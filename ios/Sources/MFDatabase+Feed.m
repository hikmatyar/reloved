/* Copyright (c) 2013 Meep Factory OU */

#import "JSONKit.h"
#import "MFDatabase+Feed.h"
#import "MFDatabase+Post.h"
#import "MFDatabaseProxy.h"
#import "MFFeed.h"
#import "MFPost.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangeFeedsNotification = @"MFDatabaseDidChangeFeeds";

#define FEED_EXPIRES 24.0F * 60.0F * 60.0F
#define FEED_EXPIRES_HISTORY 24.0F * 60.0F * 60.0F * 7.0F
#define FEED_EXPIRES_RECENTS 24.0F * 60.0F * 60.0F * 3.0F
#define FEED_BOOKMARKS @"bookmarks"
#define FEED_HISTORY @"history"
#define FEED_RECENTS @"recents"

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

+ (NSString *)feedTableName
{
    return TABLE_FEED;
}

+ (NSTimeInterval)feedExpires
{
    return FEED_EXPIRES;
}

+ (NSTimeInterval)feedExpiresHistory
{
    return FEED_EXPIRES_HISTORY;
}

+ (NSTimeInterval)feedExpiresRecents
{
    return FEED_EXPIRES_RECENTS;
}

+ (NSString *)feedIdentifierBookmarks
{
    return FEED_BOOKMARKS;
}

+ (NSString *)feedIdentifierHistory
{
    return FEED_HISTORY;
}

+ (NSString *)feedIdentifierRecents
{
    return FEED_RECENTS;
}

- (void)attach_proxy_feeds
{
    [self.store setObjectUnlessExists:[[NSDictionary dictionary] JSONData] forKey:FEED_BOOKMARKS inTable:TABLE_FEED];
    [m_proxies addObject:[[MFDatabaseProxy_Feed alloc] initWithDatabase:self]];
}

- (MFFeed *)feedForIdentifier:(NSString *)identifier ttl:(NSTimeInterval *)ttl
{
    NSDictionary *attributes = [[m_store objectForKey:identifier inTable:TABLE_FEED ttl:ttl] objectFromJSONData];
    
    if(ttl && attributes) {
        if([identifier isEqualToString:FEED_HISTORY]) {
            *ttl = *ttl - FEED_EXPIRES_HISTORY;
        } else if([identifier isEqualToString:FEED_RECENTS]) {
            *ttl = *ttl - FEED_EXPIRES_RECENTS;
        } else {
            *ttl = *ttl - FEED_EXPIRES;
        }
    }
    
    return ([attributes isKindOfClass:[NSDictionary class]]) ? [[MFFeed alloc] initWithAttributes:attributes] : nil;
}

- (void)setFeed:(MFFeed *)feed forIdentifier:(NSString *)identifier ttl:(NSTimeInterval *)ttl
{
    NSTimeInterval expires = [NSDate timeIntervalSinceReferenceDate];
    
    if([identifier isEqualToString:FEED_HISTORY]) {
        expires += FEED_EXPIRES_HISTORY;
    } else if([identifier isEqualToString:FEED_RECENTS]) {
        expires += FEED_EXPIRES_RECENTS;
    } else {
        expires += FEED_EXPIRES;
    }
    
    [m_store setObject:(feed) ? [feed.attributes JSONData] : nil
               expires:expires
                forKey:identifier
               inTable:TABLE_FEED];
    
    if(ttl && [m_store objectForKey:identifier inTable:TABLE_FEED ttl:ttl]) {
        if([identifier isEqualToString:FEED_HISTORY]) {
            *ttl = *ttl - FEED_EXPIRES_HISTORY;
        } else if([identifier isEqualToString:FEED_RECENTS]) {
            *ttl = *ttl - FEED_EXPIRES_RECENTS;
        } else {
            *ttl = *ttl - FEED_EXPIRES;
        }
    }
    
    [self addUpdate:MFDatabaseDidChangeFeedsNotification change:identifier];
}

- (NSArray *)postsForFeed:(NSString *)identifier
{
    return [m_store associationsForKey:identifier inTable:TABLE_FEED forTable:[self.class postTableName] usingBlock:^id (NSString *key, NSData *value) {
        return [[MFPost alloc] initWithAttributes:[value objectFromJSONData]];
    }];
}

- (void)setPosts:(NSArray *)posts forFeed:(NSString *)identifier
{
    [m_store dissociateKey:identifier inTable:TABLE_FEED withKeysInTable:[self.class postTableName]];
    [self addPosts:posts forFeed:identifier];
}

- (void)addPosts:(NSArray *)posts forFeed:(NSString *)identifier
{
    for(MFPost *post in posts) {
        [m_store associateKey:identifier inTable:TABLE_FEED withKey:post.identifier inTable:[self.class postTableName]];
    }
    
    [self addUpdate:MFDatabaseDidChangeFeedsNotification change:identifier];
}

- (void)replacePosts:(NSArray *)posts forFeed:(NSString *)identifier
{
    for(MFPost *post in posts) {
        [m_store dissociateKey:identifier inTable:TABLE_FEED withKey:post.identifier inTable:[self.class postTableName]];
        [m_store associateKey:identifier inTable:TABLE_FEED withKey:post.identifier inTable:[self.class postTableName]];
    }
    
    [self addUpdate:MFDatabaseDidChangeFeedsNotification change:identifier];
}

@end
