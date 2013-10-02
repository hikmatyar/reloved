/* Copyright (c) 2013 Meep Factory OU */

#import "MFImageButton.h"
#import "MFNewPostProgressView.h"
#import "MFNewPostProgressViewDelegate.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFNewPostProgressView

+ (CGFloat)preferredHeight
{
    return 75.0F;
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
            CGRect cellRect = CGRectMake(0.0F, 0.0F, roundf(frame.size.width / m_items.count), frame.size.height);
            
            for(NSString *item in m_items) {
                MFImageButton *button = [[MFImageButton alloc] initWithFrame:cellRect];
                
                button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                button.imageTopPadding = 3.0F;
                button.textTopPadding = 2.0F;
                button.verticalBias = 0.0F;
                button.titleLabel.font = [UIFont themeFontOfSize:8.0F];
                button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                button.tag = ++tag;
                
                [button setTitleColor:[UIColor themeTextColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
                [button setImage:[UIImage imageNamed:@"NewPost-Progress-Unselected.png"] forState:UIControlStateNormal];
                [button setTitle:item forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"NewPost-Progress-Selected.png"] forState:UIControlStateSelected];
                [button setImage:[UIImage imageNamed:@"NewPost-Progress-Selected.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
                [button setTitle:item.uppercaseString forState:UIControlStateSelected];
                [button setTitle:item.uppercaseString forState:UIControlStateSelected | UIControlStateHighlighted];
                cellRect.origin.x += cellRect.size.width;
                [self addSubview:button];
            }
        }
        
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        separatorView.backgroundColor = [UIColor themeMenuSeparatorColor];
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
    self = [super initWithFrame:frame];
    
    if(self) {
        m_selectedIndex = NSNotFound;
    }
    
    return self;
}

@end
