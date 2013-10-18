/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase+Feed.h"
#import "MFDatabase+Recents.h"
#import "MFPost.h"

NSString *MFDatabaseDidChangeRecentsNotification = @"MFDatabaseDidChangeRecents";

@implementation MFDatabase(Recents)

- (void)addRecentPost:(MFPost *)post
{
    if(post) {
        [self replacePosts:[NSArray arrayWithObject:post] forFeed:[MFDatabase feedIdentifierRecents]];
        [self addUpdate:MFDatabaseDidChangeRecentsNotification change:post.identifier];
    }
}

@end
