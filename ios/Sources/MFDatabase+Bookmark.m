/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase+Bookmark.h"
#import "MFDatabase+Feed.h"
#import "MFDatabase+Post.h"
#import "MFPreferences.h"
#import "MFPost.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangeBookmarksNotification = @"MFDatabaseDidChangeBookmarks";

@implementation MFDatabase(Bookmark)

- (BOOL)isBookmarkedForPost:(MFPost *)post
{
    for(NSString *bookmark in [MFPreferences sharedPreferences].bookmarks) {
        if([post.identifier isEqualToString:bookmark]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setBookmarked:(BOOL)bookmarked forPost:(MFPost *)post
{
    MFPreferences *preferences = [MFPreferences sharedPreferences];
    NSArray *bookmarks = preferences.bookmarks;
    
    if(bookmarked) {
        NSMutableArray *b;
        
        if([bookmarks containsObject:post.identifier]) {
            return;
        }
        
        b = (bookmarks) ? [[NSMutableArray alloc] initWithArray:bookmarks] : [[NSMutableArray alloc] init];
        [b addObject:post.identifier];
        preferences.bookmarks = b;
        [m_store associateKey:[self.class feedIdentifierBookmarks] inTable:[self.class feedTableName] withKey:post.identifier inTable:[self.class postTableName]];
        [self addUpdate:MFDatabaseDidChangeBookmarksNotification change:post.identifier];
    } else {
        NSMutableArray *b;
        
        if(![bookmarks containsObject:post.identifier]) {
            return;
        }
        
        b = [[NSMutableArray alloc] initWithArray:bookmarks];
        [b removeObject:post.identifier];
        preferences.bookmarks = b;
        [m_store dissociateKey:[self.class feedIdentifierBookmarks] inTable:[self.class feedTableName] withKey:post.identifier inTable:[self.class postTableName]];
        [self addUpdate:MFDatabaseDidChangeBookmarksNotification change:post.identifier];
    }
}

@end
