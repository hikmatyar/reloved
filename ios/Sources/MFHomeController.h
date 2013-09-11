/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFHomeController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    @private
    NSArray *m_menu;
}

- (IBAction)menu:(id)sender;

@end
