/* Copyright (c) 2013 Meep Factory OU */

#import "MFFeedController.h"

@interface MFEventsController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    @private
    NSArray *m_events;
}

- (IBAction)menu:(id)sender;

@end
