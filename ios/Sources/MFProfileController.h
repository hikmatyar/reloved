/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormPickerFieldDataSource.h"
#import "MFFormPickerFieldDelegate.h"

@class MBProgressHUD, MFFormAccessory, MFForm, MFUserDetails;

@interface MFProfileController : UIViewController <MFFormPickerFieldDataSource, MFFormPickerFieldDelegate, UIAlertViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    @private
    MFFormAccessory *m_accessory;
    BOOL m_allowsEmptyFields;
    NSArray *m_countries;
    MBProgressHUD *m_hud;
    MFUserDetails *m_details;
}

@property (nonatomic, assign) BOOL allowsEmptyFields;

@end
