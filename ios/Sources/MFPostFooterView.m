/* Copyright (c) 2013 Meep Factory OU */

#import "MFPostFooterView.h"
#import "MFPostFooterViewDelegate.h"
#import "UIButton+Additions.h"

#define PADDING_TOP 10.0F
#define PADDING 5.0F

@implementation MFPostFooterView

+ (CGFloat)preferredHeight
{
    return 50.0F;
}

@synthesize delegate = m_delegate;

- (IBAction)leftButton:(id)sender
{
    if([m_delegate respondsToSelector:@selector(footerViewDidSelectSave:)]) {
        [m_delegate footerViewDidSelectSave:self];
    }
}

- (IBAction)middleButton:(id)sender
{
    if([m_delegate respondsToSelector:@selector(footerViewDidSelectShare:)]) {
        [m_delegate footerViewDidSelectShare:self];
    }
}

- (IBAction)rightButton:(id)sender
{
    if([m_delegate respondsToSelector:@selector(footerViewDidSelectAddToCart:)]) {
        [m_delegate footerViewDidSelectAddToCart:self];
    }
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        UIButton *button;
        
        button = [UIButton themeButtonWithFrame:CGRectInset(CGRectMake(0.0F, PADDING_TOP, floorf(1.0F / 3.0F * frame.size.width), frame.size.height - PADDING_TOP), PADDING, PADDING)];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [button addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:NSLocalizedString(@"Post.Action.Save", nil) forState:UIControlStateNormal];
        [self addSubview:button];
        
        button = [UIButton themeButtonWithFrame:CGRectInset(CGRectMake(floorf(1.0F / 3.0F * frame.size.width), PADDING_TOP, floorf(1.0F / 3.0F * frame.size.width), frame.size.height - PADDING_TOP), PADDING, PADDING)];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [button addTarget:self action:@selector(middleButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:NSLocalizedString(@"Post.Action.Share", nil) forState:UIControlStateNormal];
        [self addSubview:button];
        
        button = [UIButton themeButtonWithFrame:CGRectInset(CGRectMake(floorf(2.0F / 3.0F * frame.size.width), PADDING_TOP, floorf(1.0F / 3.0F * frame.size.width), frame.size.height - PADDING_TOP), PADDING, PADDING)];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [button addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:NSLocalizedString(@"Post.Action.AddToCart", nil) forState:UIControlStateNormal];
        [self addSubview:button];
    }
    
    return self;
}

@end
