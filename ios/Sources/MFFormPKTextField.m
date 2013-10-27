/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormPKTextField.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFFormPKTextField

+ (CGFloat)preferredHeight
{
    return 46.0F;
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.backgroundColor = [UIColor themeInputBackgroundColor];
        self.font = [UIFont themeFontOfSize:14.0F];
        self.borderStyle = UITextBorderStyleNone;
        self.textColor = [UIColor themeInputTextColor];
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 17.0F, 20.0F)];
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return self;
}
@end
