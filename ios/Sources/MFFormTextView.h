/* Copyright (c) 2013 Meep Factory OU */

#import "MFForm.h"

@interface MFFormTextView : UITextView <MFFormElement>
{
    @private
    UILabel *m_placeholderLabel;
}

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

@end
