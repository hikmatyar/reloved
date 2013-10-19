/* Copyright (c) 2013 Meep Factory OU */

#import "MFForm.h"

@interface MFFormTextField : UITextField <MFFormElement>
{
    @private
    NSInteger m_maxTextLength;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, retain) NSString *leftText;
@property (nonatomic, assign) NSInteger maxTextLength;

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
