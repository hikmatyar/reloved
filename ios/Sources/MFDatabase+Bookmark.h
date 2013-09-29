/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFPost;

extern NSString *MFDatabaseDidChangeBookmarksNotification;

@interface MFDatabase(Bookmark)

- (BOOL)isBookmarkedForPost:(MFPost *)post;
- (void)setBookmarked:(BOOL)bookmarked forPost:(MFPost *)post;

@end
