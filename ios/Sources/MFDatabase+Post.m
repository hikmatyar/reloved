/* Copyright (c) 2013 Meep Factory OU */

#import "JSONKit.h"
#import "MFDatabase+Feed.h"
#import "MFDatabase+Post.h"
#import "MFDatabaseProxy.h"
#import "MFPost.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangePostsNotification = @"MFDatabaseDidChangePosts";

#define TABLE_POSTS @"posts"

@interface MFDatabaseProxy_Post : MFDatabaseProxy

@end

@implementation MFDatabaseProxy_Post

#pragma mark MFDatabaseProxy

- (void)invalidateObjects
{
    NSMutableSet *posts = [[NSMutableSet alloc] init];
    
    [m_database.store invalidateObjectsInTable:TABLE_POSTS usingBlock:^(NSString *table, NSString *key) {
        [posts addObject:key];
    }];
    
    if(posts.count > 0) {
        [m_database.state removeObjectForKey:TABLE_POSTS];
        [m_database addUpdate:MFDatabaseDidChangePostsNotification changes:posts];
    }
}

@end

#pragma mark -

@implementation MFDatabase(Post)

+ (NSString *)postTableName
{
    return TABLE_POSTS;
}

- (void)attach_proxy_posts
{
    [m_proxies addObject:[[MFDatabaseProxy_Post alloc] initWithDatabase:self]];
}

- (NSArray *)posts
{
    NSArray *s_posts = [m_state objectForKey:TABLE_POSTS];
    
    if(!s_posts) {
        NSMutableArray *posts = [[NSMutableArray alloc] init];
        
        for(MFPost *post in [m_store allObjectsInTable:TABLE_POSTS usingBlock:^id (NSString *key, NSData *value) {
            return [[MFPost alloc] initWithAttributes:[value objectFromJSONData]];
        }].objectEnumerator) {
            [posts addObject:post];
        }
        
        [m_state setObject:posts forKey:TABLE_POSTS];
        s_posts = posts;
    }
    
    return s_posts;
}

- (void)setPosts:(NSArray *)posts
{
    NSArray *s_posts = [m_state objectForKey:TABLE_POSTS];
    
    if(!posts || s_posts != posts) {
        NSTimeInterval expires = [NSDate timeIntervalSinceReferenceDate] + [self.class feedExpires];
        
        [m_state setValue:posts forKey:TABLE_POSTS];
        [m_store removeAllObjectsInTable:TABLE_POSTS];
        
        for(MFPost *post in posts) {
            [m_store setObject:[post.attributes JSONData] expires:expires forKey:post.identifier inTable:TABLE_POSTS];
        }
        
        [self addUpdate:MFDatabaseDidChangePostsNotification change:nil];
    }
}

- (MFPost *)postForIdentifier:(NSString *)identifier
{
    for(MFPost *post in self.posts) {
        if([post.identifier isEqualToString:identifier]) {
            return post;
        }
    }
    
    return nil;
}

- (void)setPost:(MFPost *)post forIdentifier:(NSString *)identifier
{
    [m_state removeObjectForKey:TABLE_POSTS];
    [m_store setObject:[post.attributes JSONData] expires:[NSDate timeIntervalSinceReferenceDate] + [self.class feedExpires] forKey:post.identifier inTable:TABLE_POSTS];
    [self addUpdate:MFDatabaseDidChangePostsNotification change:identifier];
}

@end
