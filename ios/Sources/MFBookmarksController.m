/* Copyright (c) 2013 Meep Factory OU */

#import "MFBookmarksController.h"
#import "MFTableView.h"
#import "MFWebFeed.h"

@implementation MFBookmarksController

#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    self.tableView.placeholder = NSLocalizedString(@"Bookmarks.Label.NoData", nil);
}

#pragma mark NSObject

- (id)init
{
    self = [self initWithFeed:[MFWebFeed sharedFeedOfKind:kMFWebFeedKindBookmarks]];
    
    if(self) {
        self.title = NSLocalizedString(@"Bookmarks.Title", nil);
    }
    
    return self;
}

@end
