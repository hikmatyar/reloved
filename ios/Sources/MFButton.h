/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFButton : UIButton
{
    @private
    id m_userInfo;
}

@property (nonatomic, retain) id userInfo;

@end
