/* Copyright (c) 2013 Meep Factory OU */

#import "MFHomeHeaderView.h"
#import "MFHomeHeaderViewDelegate.h"
#import "MFMenuItem.h"
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

@dynamic item;

- (MFMenuItem *)item
{
    return m_item;
}

- (void)setItem:(MFMenuItem *)item
{
    if(m_item != item) {
        m_item = item;
        m_itemLabel.text = item.title;
    }
}

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
        
        m_itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0F, 162.0F, 300.0F, 31.0F)];
        m_itemLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        m_itemLabel.backgroundColor = [UIColor grayColor];
        m_itemLabel.font = [UIFont themeFontOfSize:12.0F];
        m_itemLabel.textAlignment = NSTextAlignmentCenter;
        m_itemLabel.text = @"GUCCI\n180";
        m_itemLabel.numberOfLines = 0;
        [self addSubview:m_itemLabel];
        
        m_itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(78.0F, 9.0F, 164.0F, 152.0F)];
        m_itemImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        m_itemImageView.backgroundColor = [UIColor grayColor];
        [self addSubview:m_itemImageView];
    }
    
    return self;
}

@end
