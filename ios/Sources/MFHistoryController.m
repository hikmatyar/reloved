/* Copyright (c) 2013 Meep Factory OU */

#import "MFHistoryController.h"
#import "MFTableView.h"
#import "MFWebFeed.h"

@implementation MFHistoryController

#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    self.tableView.placeholder = NSLocalizedString(@"History.Label.NoData", nil);
}

#pragma mark NSObject

- (id)init
{
    self = [self initWithFeed:[MFWebFeed sharedFeedOfKind:kMFWebFeedKindHistory]];
    
    if(self) {
        self.title = NSLocalizedString(@"History.Title", nil);
    }
    
    return self;
}

@end
