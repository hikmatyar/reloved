/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormPickerFieldDataSource.h"
#import "MFFormPickerFieldDelegate.h"

@class MBProgressHUD, MFFormAccessory, MFForm;

@interface MFProfileController : UIViewController <MFFormPickerFieldDataSource, MFFormPickerFieldDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    @private
    MFFormAccessory *m_accessory;
    MBProgressHUD *m_hudView;
}

@end
