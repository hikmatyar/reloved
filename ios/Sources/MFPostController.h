/* Copyright (c) 2013 Meep Factory OU */

#import "MFPostFooterViewDelegate.h"
#import "MFPostHeaderViewDelegate.h"

@class MBProgressHUD, MFWebPost;

@interface MFPostController : UIViewController <MFPostFooterViewDelegate, MFPostHeaderViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    @private
    BOOL m_userInteractionEnabled;
    MBProgressHUD *m_hud;
    NSArray *m_menu;
    MFWebPost *m_post;
}

- (id)initWithPost:(MFWebPost *)post;
- (id)initWithPost:(MFWebPost *)post userInteractionEnabled:(BOOL)userInteractionEnabled;

@property (nonatomic, assign, readonly, getter = isUserInteractionEnabled) BOOL userInteractionEnabled;
@property (nonatomic, retain, readonly) MFWebPost *post;

@end
