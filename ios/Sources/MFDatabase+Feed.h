/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFFeed;

extern NSString *MFDatabaseDidChangeFeedsNotification;

@interface MFDatabase(Feed)

+ (NSString *)feedTableName;
+ (NSTimeInterval)feedExpires;
+ (NSTimeInterval)feedExpiresHistory;
+ (NSString *)feedIdentifierBookmarks;
+ (NSString *)feedIdentifierHistory;

- (MFFeed *)feedForIdentifier:(NSString *)identifier ttl:(NSTimeInterval *)ttl;
- (void)setFeed:(MFFeed *)feed forIdentifier:(NSString *)identifier ttl:(NSTimeInterval *)ttl;

- (NSArray *)postsForFeed:(NSString *)identifier;
- (void)setPosts:(NSArray *)posts forFeed:(NSString *)identifier;
- (void)addPosts:(NSArray *)posts forFeed:(NSString *)identifier;

@end