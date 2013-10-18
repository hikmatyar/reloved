/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

extern NSString *MFDatabaseDidChangeRecentsNotification;

@class MFPost;

@interface MFDatabase(Recents)

- (void)addRecentPost:(MFPost *)post;

@end
