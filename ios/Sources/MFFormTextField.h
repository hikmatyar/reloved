/* Copyright (c) 2013 Meep Factory OU */

#import "MFForm.h"

@interface MFFormTextField : UITextField <MFFormElement>

+ (CGFloat)preferredHeight;

@property (nonatomic, retain) NSString *leftText;

@end
