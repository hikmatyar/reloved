/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFFormAccessory;

@interface MFSearchController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    @private
    MFFormAccessory *m_accessory;
}

- (IBAction)menu:(id)sender;

@end
