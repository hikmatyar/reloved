/* Copyright (c) 2013 Meep Factory OU */

#import "MFHomeHeaderView.h"
#import "MFHomeHeaderViewDelegate.h"
#import "MFImageButton.h"
#import "MFImageView.h"
#import "MFMenuItem.h"
#import "UIButton+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFHomeHeaderView

+ (CGFloat)preferredHeight
{
    return 256.0F;
}

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
        UIButton *shopByColorButton = [MFImageButton themeButtonWithFrame:CGRectMake(10.0F, 194.0F, 160.0F, 49.0F)];
        UIButton *shopByDressButton = [MFImageButton themeButtonWithFrame:CGRectMake(160.0F, 194.0F, 150.0F, 49.0F)];
        UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 194.0F, frame.size.width, 1.0F)];
        UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, frame.size.height - 1.0F, frame.size.width, 1.0F)];
        UIImageView *disclosureIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Disclosure-Indicator.png"]];
        
        topSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        topSeparatorView.backgroundColor = [UIColor themeSeparatorTopColor];
        [self addSubview:topSeparatorView];
        
        bottomSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        bottomSeparatorView.backgroundColor = [UIColor themeSeparatorBottomColor];
        [self addSubview:bottomSeparatorView];
        
        disclosureIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        disclosureIndicatorView.center = CGPointMake(frame.size.width - 20.0F, 91.0F);
        [self addSubview:disclosureIndicatorView];
        
        [shopByColorButton addTarget:self action:@selector(shopByColor:) forControlEvents:UIControlEventTouchUpInside];
        [shopByColorButton setImage:[UIImage imageNamed:@"Home-ShopByColor.png"] forState:UIControlStateNormal];
        [shopByColorButton setTitle:NSLocalizedString(@"Home.Action.ShopByColor", nil) forState:UIControlStateNormal];
        shopByColorButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:shopByColorButton];
        
        [shopByDressButton addTarget:self action:@selector(shopByDress:) forControlEvents:UIControlEventTouchUpInside];
        [shopByDressButton setImage:[UIImage imageNamed:@"Home-ShopByDress.png"] forState:UIControlStateNormal];
        [shopByDressButton setTitle:NSLocalizedString(@"Home.Action.ShopByDress", nil) forState:UIControlStateNormal];
        shopByDressButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:shopByDressButton];
        
        m_itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0F, 162.0F, 300.0F, 31.0F)];
        m_itemLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        m_itemLabel.backgroundColor = [UIColor clearColor];
        m_itemLabel.font = [UIFont themeFontOfSize:12.0F];
        m_itemLabel.textAlignment = NSTextAlignmentCenter;
        m_itemLabel.text = @"GUCCI\n180";
        m_itemLabel.numberOfLines = 0;
        [self addSubview:m_itemLabel];
        
        m_itemImageView = [[MFImageView alloc] initWithFrame:CGRectMake(78.0F, 9.0F, 164.0F, 152.0F)];
        m_itemImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        m_itemImageView.layer.borderColor = [UIColor themeImageBorderColor].CGColor;
        m_itemImageView.layer.borderWidth = 1.0F;
        m_itemImageView.placeholderImage = [UIImage imageNamed:@"Home-Featured-Placeholder.png"];
        [self addSubview:m_itemImageView];
    }
    
    return self;
}

@end
