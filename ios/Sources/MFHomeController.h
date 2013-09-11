/* Copyright (c) 2013 Meep Factory OU */

#import "MFHomeHeaderViewDelegate.h"

@interface MFHomeController : UIViewController <MFHomeHeaderViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    @private
    NSArray *m_menu;
}

- (IBAction)menu:(id)sender;

@end
