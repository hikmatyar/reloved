/* Copyright (c) 2013 Meep Factory OU */

#import "MFForm.h"

@implementation MFForm

- (void)scrollToView:(UIView *)view animated:(BOOL)animated
{
    UIView *superview = view.superview;
    
    while(superview && superview != self) {
        view = superview;
        superview = view.superview;
    }
    
    if(superview == self) {
        [self scrollRectToVisible:view.frame animated:animated];
    }
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.contentInset = UIEdgeInsetsMake(10.0F, 10.0F, 10.0F, 10.0F);
        self.showsHorizontalScrollIndicator = NO;
    }
    
    return self;
}

- (void)layoutSubviews
{
    UIEdgeInsets insets = self.contentInset;
    CGRect rect = { { 0.0F, 0.0F }, { self.frame.size.width - insets.left - insets.right, -insets.top } };
    Protocol *protocol = @protocol(MFFormElement);
    BOOL inForm = NO;
    
    for(UIView *subview in self.subviews) {
        if(!subview.hidden && subview.tag > 0) {
            CGSize size = subview.frame.size;
            
            if([subview conformsToProtocol:protocol]) {
                if(!inForm) {
                    rect.size.height += insets.top;
                }
                
                inForm = YES;
            } else {
                rect.size.height += insets.top;
                inForm = NO;
            }
            
            subview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            subview.frame = CGRectMake(0.0F, rect.size.height, rect.size.width, size.height);
            rect.size.height += size.height;
        }
    }
    
    if(rect.size.height < 0.0F) {
        rect.size.height = 0.0F;
    }
    
    self.contentSize = rect.size;
    
    [super layoutSubviews];
}

@end