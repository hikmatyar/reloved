/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase+Bookmark.h"
#import "MFPost.h"

NSString *MFDatabaseDidChangeBookmarksNotification = @"MFDatabaseDidChangeBookmarks";

@implementation MFDatabase(Bookmark)

- (BOOL)isBookmarkedForPost:(MFPost *)post
{
    return NO;
}

- (void)setBookmarked:(BOOL)bookmarked forPost:(MFPost *)post
{
}

@end
