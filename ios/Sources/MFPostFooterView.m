/* Copyright (c) 2013 Meep Factory OU */

#import "MFPostFooterView.h"
#import "MFPostFooterViewDelegate.h"
#import "UIButton+Additions.h"

#define PADDING_TOP 10.0F
#define PADDING 5.0F

#define TAG_LEFTBUTTON 1
#define TAG_RIGHTBUTTON 2

@implementation MFPostFooterView

+ (CGFloat)preferredHeight
{
    return 60.0F;
}

@synthesize delegate = m_delegate;

- (IBAction)leftButton:(id)sender
{
    if([m_delegate respondsToSelector:@selector(footerViewDidSelectSave:)]) {
        [m_delegate footerViewDidSelectSave:self];
    }
}

- (IBAction)rightButton:(id)sender
{
    if([m_delegate respondsToSelector:@selector(footerViewDidSelectShare:)]) {
        [m_delegate footerViewDidSelectShare:self];
    }
}

@dynamic leftButton;

- (UIButton *)leftButton
{
    return (UIButton *)[self viewWithTag:TAG_LEFTBUTTON];
}

@dynamic rightButton;

- (UIButton *)rightButton
{
    return (UIButton *)[self viewWithTag:TAG_RIGHTBUTTON];
}

@dynamic leftTitle;

- (NSString *)leftTitle
{
    return [self.leftButton titleForState:UIControlStateNormal];
}

- (void)setLeftTitle:(NSString *)leftTitle
{
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        UIButton *button;
        
        button = [UIButton themeActionWithFrame:CGRectInset(CGRectMake(0.0F, PADDING_TOP, floorf(1.0F / 2.0F * frame.size.width), frame.size.height - PADDING_TOP), PADDING, PADDING)];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        button.tag = TAG_LEFTBUTTON;
        [button addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"Post-Save.png"] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"Post.Action.Save", nil) forState:UIControlStateNormal];
        [self addSubview:button];
        
        button = [UIButton themeActionWithFrame:CGRectInset(CGRectMake(floorf(1.0F / 2.0F * frame.size.width), PADDING_TOP, floorf(1.0F / 2.0F * frame.size.width), frame.size.height - PADDING_TOP), PADDING, PADDING)];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        button.tag = TAG_RIGHTBUTTON;
        [button addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"Post-Share.png"] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"Post.Action.Share", nil) forState:UIControlStateNormal];
        [self addSubview:button];
    }
    
    return self;
}

@end
