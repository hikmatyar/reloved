/* Copyright (c) 2013 Meep Factory OU */

#import "MFPostFooterViewDelegate.h"
#import "MFPostHeaderViewDelegate.h"

@class MBProgressHUD, MFWebPost;

@interface MFPostController : UIViewController <MFPostFooterViewDelegate, MFPostHeaderViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    @private
    MBProgressHUD *m_hudView;
    NSArray *m_menu;
    MFWebPost *m_post;
}

- (id)initWithPost:(MFWebPost *)post;

@property (nonatomic, retain, readonly) MFWebPost *post;

@end
