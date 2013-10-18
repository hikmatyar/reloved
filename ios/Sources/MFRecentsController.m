/* Copyright (c) 2013 Meep Factory OU */

#import "MFRecentsController.h"
#import "MFTableView.h"
#import "MFWebFeed.h"

@implementation MFRecentsController

#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    self.tableView.placeholder = NSLocalizedString(@"Recents.Label.NoData", nil);
}

#pragma mark NSObject

- (id)init
{
    self = [self initWithFeed:[MFWebFeed sharedFeedOfKind:kMFWebFeedKindRecents]];
    
    if(self) {
        self.title = NSLocalizedString(@"Recents.Title", nil);
    }
    
    return self;
}

@end
