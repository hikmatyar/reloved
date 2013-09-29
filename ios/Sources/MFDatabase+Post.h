/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFPost;

extern NSString *MFDatabaseDidChangePostsNotification;

@interface MFDatabase(Post)

@property (nonatomic, copy) NSArray *posts;
- (MFPost *)postForIdentifier:(NSString *)identifier;
- (void)setPost:(MFPost *)post forIdentifier:(NSString *)identifier;

@end
