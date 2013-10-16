/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MBProgressHUD, MFFormAccessory, MFForm;

@interface MFProfileController : UIViewController
{
    @private
    MFFormAccessory *m_accessory;
    MFForm *m_form;
    MBProgressHUD *m_hudView;
}

@end
