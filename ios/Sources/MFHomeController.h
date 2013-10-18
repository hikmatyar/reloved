/* Copyright (c) 2013 Meep Factory OU */

#import "MFHomeHeaderViewDelegate.h"
#import "MFOptionPickerControllerDelegate.h"

@interface MFHomeController : UIViewController <MFHomeHeaderViewDelegate, MFOptionPickerControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    @private
    NSArray *m_menu;
}

- (IBAction)menu:(id)sender;

@end
