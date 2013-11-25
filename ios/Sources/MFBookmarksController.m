/* Copyright (c) 2013 Meep Factory OU */

#import "MFBookmarksController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFTableView.h"
#import "MFWebFeed.h"
#import "UIViewController+MFSideMenuAdditions.h"

@implementation MFBookmarksController

- (IBAction)menu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
}

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
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
        self.title = NSLocalizedString(@"Bookmarks.Title", nil);
    }
    
    return self;
}

@end
