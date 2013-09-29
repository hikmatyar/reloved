/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase+Feed.h"
#import "MFFeed.h"

NSString *MFDatabaseDidChangeFeedsNotification = @"MFDatabaseDidChangeFeeds";

@implementation MFDatabase(Feed)

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
