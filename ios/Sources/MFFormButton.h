/* Copyright (c) 2013 Meep Factory OU */

#import "MFForm.h"

@interface MFFormButton : UIButton <MFFormElement>
{
    @private
    NSString *m_placeholder;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, retain) NSString *placeholder;

@end
