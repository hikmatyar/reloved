/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFNotice;

@interface MFNoticeController : UIViewController
{
    @private
    MFNotice *m_notice;
}

- (id)initWithNotice:(MFNotice *)notice;

@property (nonatomic, retain, readonly) MFNotice *notice;

@end
