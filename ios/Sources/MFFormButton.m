/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormButton.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFFormButton

+ (CGFloat)preferredHeight
{
    return 50.0F;
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        UIImageView *disclosureView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 21.0F, roundf(0.5F * (frame.size.height - 17.0F)), 10.0F, 17.0F)];
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, frame.size.height - 1.0F, frame.size.width, 1.0F)];
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.contentEdgeInsets = UIEdgeInsetsMake(0.0F, 17.0F, 0.0F, 0.0F);
        self.backgroundColor = [UIColor themeButtonBackgroundColor];
        self.titleLabel.font = [UIFont themeFontOfSize:16.0F];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self setTitleColor:[UIColor themeButtonTextColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor themeButtonTextHighlightColor] forState:UIControlStateHighlighted];
        
        disclosureView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        disclosureView.image = [UIImage imageNamed:@"Disclosure-Indicator.png"];
        [self addSubview:disclosureView];
        
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        separatorView.backgroundColor = [UIColor themeSeparatorBottomColor];
        [self addSubview:separatorView];
    }
    
    return self;
}

@end
