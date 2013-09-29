/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase+Post.h"
#import "MFPost.h"

NSString *MFDatabaseDidChangePostsNotification = @"MFDatabaseDidChangePosts";

@implementation MFDatabase(Post)

@dynamic posts;

- (NSArray *)posts
{
    return nil;
}

- (void)setPosts:(NSArray *)posts
{
}

- (MFPost *)postForIdentifier:(NSString *)identifier
{
    return nil;
}

- (void)setPost:(MFPost *)post forIdentifier:(NSString *)identifier
{
}

@end
