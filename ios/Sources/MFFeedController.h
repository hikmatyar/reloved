/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFWebFeed;

@interface MFFeedController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    @private
    MFWebFeed *m_feed;
}

@property (nonatomic, retain) MFWebFeed *feed;
@property (nonatomic, retain, readonly) UITableView *tableView;

@end
