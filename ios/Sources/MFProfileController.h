/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MBProgressHUD, MFFormAccessory, MFForm;

@interface MFProfileController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    @private
    MFFormAccessory *m_accessory;
    MBProgressHUD *m_hudView;
}

@end
