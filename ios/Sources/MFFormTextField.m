/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormTextField.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@interface MFFormTextField_LeftView : UILabel

@end

@implementation MFFormTextField_LeftView

#pragma mark UIView

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:CGRectOffset(rect, 0.0F, -1.0F)];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    size = [super sizeThatFits:size];
    
    size.width += 17.0F;
    
    return size;
}

@end

#pragma mark -

@implementation MFFormTextField

+ (CGFloat)preferredHeight
{
    return 46.0F;
}

@dynamic leftText;

- (NSString *)leftText
{
    UIView *leftView = self.leftView;
    
    return ([leftView isKindOfClass:[UILabel class]]) ? ((UILabel *)leftView).text : nil;
}

- (void)setLeftText:(NSString *)leftText
{
    UILabel *leftView = [[MFFormTextField_LeftView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 100.0F, self.frame.size.height)];
    
    leftView.font = self.font;
    leftView.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    leftView.numberOfLines = 0;
    leftView.textAlignment = NSTextAlignmentRight;
    leftView.textColor = self.textColor;
    leftView.text = leftText;
    [leftView sizeToFit];
    
    self.leftView = leftView;
}

@synthesize maxTextLength = m_maxTextLength;

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return (m_maxTextLength == 0 || (self.text.length + string.length - range.length) < m_maxTextLength) ? YES : NO;
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
