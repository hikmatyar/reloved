/* Copyright (c) 2013 Meep Factory OU */

#import "MFForm.h"

@interface MFFormTextView : UITextView <MFFormElement>
{
    @private
    UILabel *m_placeholderLabel;
    NSInteger m_maxTextLength;
}

@property (nonatomic, assign) NSInteger maxTextLength;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
