/* Copyright (c) 2013 Meep Factory OU */

#import "MFHomeHeaderView.h"
#import "MFHomeHeaderViewDelegate.h"
#import "UIButton+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFHomeHeaderView

- (IBAction)shopByColor:(id)sender
{
    [m_delegate headerViewDidSelectShopByColor:self];
}

- (IBAction)shopByDress:(id)sender
{
    [m_delegate headerViewDidSelectShopByDress:self];
}

- (IBAction)shopByFeatured:(id)sender
{
    [m_delegate headerViewDidSelectShopByFeatured:self];
}

@synthesize delegate = m_delegate;

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        UIButton *shopByColorButton = [UIButton themeButtonWithFrame:CGRectMake(10.0F, 194.0F, 160.0F, 49.0F)];
        UIButton *shopByDressButton = [UIButton themeButtonWithFrame:CGRectMake(160.0F, 194.0F, 150.0F, 49.0F)];
        
        [shopByColorButton addTarget:self action:@selector(shopByColor:) forControlEvents:UIControlEventTouchUpInside];
        [shopByColorButton setTitle:NSLocalizedString(@"Home.Action.ShopByColor", nil) forState:UIControlStateNormal];
        shopByColorButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:shopByColorButton];
        
        [shopByDressButton addTarget:self action:@selector(shopByDress:) forControlEvents:UIControlEventTouchUpInside];
        [shopByDressButton setTitle:NSLocalizedString(@"Home.Action.ShopByDress", nil) forState:UIControlStateNormal];
        shopByDressButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:shopByDressButton];
    }
    
    return self;
}

@end
