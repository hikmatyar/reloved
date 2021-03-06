/* Copyright (c) 2013 Meep Factory OU */

#import "MFImageButton.h"
#import "MFProgressView.h"
#import "MFProgressViewDelegate.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFProgressView

+ (CGFloat)preferredHeight
{
    return 60.0F;
}

- (id)initWithFrame:(CGRect)frame style:(MFProgressViewStyle)style
{
    self = [super initWithFrame:frame];
    
    if(self) {
        m_selectedIndex = NSNotFound;
        m_style = style;
    }
    
    return self;
}

@synthesize delegate = m_delegate;

@dynamic items;

- (NSArray *)items
{
    return m_items;
}

- (void)setItems:(NSArray *)items
{
    if(!MFEqual(m_items, items)) {
        CGRect frame = self.frame;
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(17.0F, 20.0F, frame.size.width - 32.0F, 1.0F)];
        NSInteger tag = 0;
        
        m_items = items;
        
        for(UIView *subview in self.subviews) {
            [subview removeFromSuperview];
        }
        
        if(m_items.count > 0) {
            CGRect cellRect = CGRectMake(0.0F, 4.0F, roundf(frame.size.width / m_items.count), frame.size.height);
            
            for(NSString *item in m_items) {
                MFImageButton *button = [[MFImageButton alloc] initWithFrame:cellRect];
                
                button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                button.imageTopPadding = 3.0F;
                button.textTopPadding = -2.0F;
                button.verticalBias = 0.0F;
                button.titleLabel.font = [UIFont themeFontOfSize:8.0F];
                button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                button.tag = ++tag;
                
                [button setTitleColor:[UIColor themeProgressTextColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor themeProgressTextSelectedColor] forState:UIControlStateSelected];
                [button setTitleColor:[UIColor themeProgressTextSelectedColor] forState:UIControlStateSelected | UIControlStateHighlighted];
                [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:item forState:UIControlStateNormal];
                
                switch(m_style) {
                    case kMFProgressViewStyleDefault:
                        [button setImage:[UIImage imageNamed:@"NewPost-Progress-Unselected.png"] forState:UIControlStateNormal];
                        [button setImage:[UIImage imageNamed:@"NewPost-Progress-Selected.png"] forState:UIControlStateSelected];
                        [button setImage:[UIImage imageNamed:@"NewPost-Progress-Selected.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
                        break;
                    case kMFProgressViewStyleCheckout:
                        [button setImage:[UIImage imageNamed:@"Checkout-Progress-Unselected.png"] forState:UIControlStateNormal];
                        [button setImage:[UIImage imageNamed:@"Checkout-Progress-Selected.png"] forState:UIControlStateSelected];
                        [button setImage:[UIImage imageNamed:@"Checkout-Progress-Selected.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
                        break;
                }
                
                [button setTitle:item.uppercaseString forState:UIControlStateSelected];
                [button setTitle:item.uppercaseString forState:UIControlStateSelected | UIControlStateHighlighted];
                cellRect.origin.x += cellRect.size.width;
                [self addSubview:button];
            }
        }
        
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        separatorView.backgroundColor = [UIColor themeProgressSeparatorColor];
        [self addSubview:separatorView];
        
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, frame.size.height - 1.0F, frame.size.width, 1.0F)];
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        separatorView.backgroundColor = [UIColor themeSeparatorTopColor];
        [self addSubview:separatorView];
    }
}

@dynamic selectedIndex;

- (NSInteger)selectedIndex
{
    return m_selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if(m_selectedIndex != selectedIndex) {
        m_selectedIndex = selectedIndex;
        
        for(UIView *subview in self.subviews) {
            if([subview isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)subview;
                
                button.selected = (m_selectedIndex != NSNotFound && button.tag == m_selectedIndex + 1) ? YES : NO;
            }
        }
    }
}

- (IBAction)action:(id)sender
{
    NSInteger tag = ((UIButton *)sender).tag;
    
    if(tag > 0 && tag <= m_items.count && tag - 1 != m_selectedIndex) {
        if(![m_delegate respondsToSelector:@selector(progressView:shouldSelectItemAtIndex:)] || [m_delegate progressView:self shouldSelectItemAtIndex:tag - 1]) {
            if(m_selectedIndex != NSNotFound) {
                ((UIButton *)[self viewWithTag:m_selectedIndex + 1]).selected = NO;
            }
            
            ((UIButton *)sender).selected = YES;
            m_selectedIndex = tag - 1;
            
            if([m_delegate respondsToSelector:@selector(progressView:didSelectItemAtIndex:)]) {
                [m_delegate progressView:self didSelectItemAtIndex:m_selectedIndex];
            }
        }
    }
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:kMFProgressViewStyleDefault];
}

@end
