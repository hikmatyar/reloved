/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormButton.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFFormButton

+ (CGFloat)preferredHeight
{
    return 50.0F;
}

+ (BOOL)hasDisclosureIndicator
{
    return YES;
}

@dynamic empty;

- (BOOL)isEmpty
{
    return (self.titleLabel.text.length == 0 || [m_placeholder isEqualToString:self.titleLabel.text]) ? YES : NO;
}

@dynamic placeholder;

- (NSString *)placeholder
{
    return m_placeholder;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if(!MFEqual(m_placeholder, placeholder)) {
        BOOL noText = (self.titleLabel.text.length == 0 || [m_placeholder isEqualToString:self.titleLabel.text]) ? YES : NO;
        
        m_placeholder = placeholder;
        
        if(noText) {
            [self setTitle:@"" forState:UIControlStateNormal];
        }
    }
}

#pragma mark UIButton

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    if(state == UIControlStateNormal) {
        if(title.length > 0) {
            [super setTitle:title forState:state];
            [self setTitleColor:[UIColor themeButtonTextColor] forState:state];
        } else {
            [super setTitle:(m_placeholder) ? m_placeholder : @"" forState:state];
            [self setTitleColor:[UIColor themeButtonTextPlaceholderColor] forState:state];
        }
    } else {
        [super setTitle:title forState:state];
    }
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, frame.size.height - 1.0F, frame.size.width, 1.0F)];
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.contentEdgeInsets = UIEdgeInsetsMake(0.0F, 17.0F, 0.0F, 0.0F);
        self.backgroundColor = [UIColor themeButtonBackgroundColor];
        self.titleLabel.font = [UIFont themeFontOfSize:16.0F];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self setTitleColor:[UIColor themeButtonTextColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor themeButtonTextHighlightColor] forState:UIControlStateHighlighted];
        
        if([self.class hasDisclosureIndicator]) {
            UIImageView *disclosureView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 21.0F, roundf(0.5F * (frame.size.height - 17.0F)), 10.0F, 17.0F)];
            
            disclosureView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            disclosureView.image = [UIImage imageNamed:@"Disclosure-Indicator.png"];
            [self addSubview:disclosureView];
        }
        
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        separatorView.backgroundColor = [UIColor themeSeparatorBottomColor];
        [self addSubview:separatorView];
    }
    
    return self;
}

@end
