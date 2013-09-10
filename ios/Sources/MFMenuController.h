/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFMenuController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    @private
    NSArray *m_menu;
}

- (IBAction)home:(id)sender;
- (IBAction)search:(id)sender;
- (IBAction)news:(id)sender;
- (IBAction)cart:(id)sender;
- (IBAction)sell:(id)sender;

@end
