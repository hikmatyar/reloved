/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFPost;

extern NSString *MFDatabaseDidChangePostsNotification;

@interface MFDatabase(Post)

+ (NSString *)postTableName;

@property (nonatomic, copy) NSArray *posts;
@property (nonatomic, copy) MFPost *featuredPost;
- (MFPost *)postForIdentifier:(NSString *)identifier;
- (void)setPost:(MFPost *)post forIdentifier:(NSString *)identifier;

@end
