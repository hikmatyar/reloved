/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormTextView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFFormTextView

+ (CGFloat)preferredHeight
{
    return 50.0F;
}

- (void)textDidChange_:(NSNotification *)notification
{
    m_placeholderLabel.hidden = (self.text.length > 0) ? YES : NO;
}

@dynamic placeholder;

- (NSString *)placeholder
{
    return m_placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    m_placeholderLabel.text = placeholder;
    [m_placeholderLabel sizeToFit];
}

@dynamic placeholderColor;

- (UIColor *)placeholderColor
{
    return m_placeholderLabel.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    m_placeholderLabel.textColor = placeholderColor;
}

#pragma mark UITextView

- (void)setFont:(UIFont *)font
{
    super.font = font;
    m_placeholderLabel.font = font;
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.backgroundColor = [UIColor themeInputBackgroundColor];
        self.font = [UIFont themeFontOfSize:14.0F];
        self.textColor = [UIColor themeInputTextColor];
        self.dataDetectorTypes = UIDataDetectorTypeNone;
        
        if([self respondsToSelector:@selector(setTextContainerInset:)]) {
            self.textContainerInset = UIEdgeInsetsMake(10.0F, 17.0F, 0.0F, 3.0F);
        }
        
        m_placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0F, 8.0F, frame.size.width - 16.0F, frame.size.height - 16.0F)];
        m_placeholderLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        m_placeholderLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        m_placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        m_placeholderLabel.numberOfLines = 0;
        m_placeholderLabel.font = self.font;
        m_placeholderLabel.backgroundColor = [UIColor clearColor];
        m_placeholderLabel.textColor = [UIColor themeInputTextPlaceholderColor];
        m_placeholderLabel.hidden = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange_:) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if(m_placeholderLabel.text.length > 0 && !m_placeholderLabel.superview) {
        m_placeholderLabel.frame = CGRectInset(([self respondsToSelector:@selector(textContainerInset)]) ? UIEdgeInsetsInsetRect(self.bounds, self.textContainerInset) : self.bounds, 5.0F, 0.0F);
        m_placeholderLabel.hidden = NO;
        [m_placeholderLabel sizeToFit];
        [self addSubview:m_placeholderLabel];
    } else {
        m_placeholderLabel.hidden = YES;
    }
    
    [super drawRect:rect];
}

#pragma mark NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
