/* Copyright (c) 2013 Meep Factory OU */

#import "MFNotice.h"
#import "MFNoticeController.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define TAG_LABEL 1000

@implementation MFNoticeController

- (UILabel *)label
{
    return (UILabel *)[self.view viewWithTag:TAG_LABEL];
}

- (id)initWithNotice:(MFNotice *)notice
{
    self = [super init];
    
    if(self) {
        m_notice = notice;
        self.navigationItem.title = m_notice.title;
    }
    
    return self;
}

@synthesize notice = m_notice;

#pragma mark UIViewController

- (void)loadView
{
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0F, 10.0F, 320.0F, 980.0F)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    
    [str beginEditing];
    
    if(m_notice.subject) {
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", m_notice.subject] attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeBoldFontOfSize:14.0F], NSFontAttributeName, nil]]];
    }
    
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", m_notice.message] attributes:
        [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeFontOfSize:14.0F], NSFontAttributeName, nil]]];
    
    [str endEditing];
    
    label.backgroundColor = [UIColor clearColor];
    label.attributedText = str;
    label.baselineAdjustment = UIBaselineAdjustmentNone;
    label.numberOfLines = 0;
    label.textColor = [UIColor themeTextColor];
    [view addSubview:label];
    [label sizeToFit];
    
    view.contentSize = label.frame.size;
    view.backgroundColor = [UIColor themeBackgroundColor];
    view.showsHorizontalScrollIndicator = NO;
    self.view = view;
}

@end
