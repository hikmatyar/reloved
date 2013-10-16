/* Copyright (c) 2013 Meep Factory OU */

#import "MFPostFooterViewDelegate.h"
#import "MFPostHeaderViewDelegate.h"

@class MFWebPost;

@interface MFPostController : UIViewController <MFPostFooterViewDelegate, MFPostHeaderViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    @private
    NSArray *m_menu;
    MFWebPost *m_post;
}

- (id)initWithPost:(MFWebPost *)post;

@end
