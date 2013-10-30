/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrand.h"
#import "MFDatabase+Brand.h"
#import "MFDatabase+State.h"
#import "MFHomeHeaderView.h"
#import "MFHomeHeaderViewDelegate.h"
#import "MFImageButton.h"
#import "MFImageView.h"
#import "MFMoney.h"
#import "MFPost.h"
#import "UIButton+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFHomeHeaderView

+ (CGFloat)preferredHeight
{
    return 256.0F;
}

- (void)invalidatePost
{
    if(!m_selectedPost || ![m_posts containsObject:m_selectedPost]) {
        m_selectedPost = m_posts.firstObject;
    }
    
    if(m_selectedPost) {
        MFBrand *brand = [[MFDatabase sharedDatabase] brandForIdentifier:m_selectedPost.brandId];
        MFMoney *price = [[MFMoney alloc] initWithValue:m_selectedPost.price currency:m_selectedPost.currency];
        
        m_postLabel.text = [NSString stringWithFormat:@"%@\n%@", ((brand.name) ? brand.name : m_selectedPost.title), price.localizedString];
        m_postImageView.URL = [[MFDatabase sharedDatabase] URLForMedia:m_selectedPost.mediaIds.firstObject size:kMFMediaSizeThumbnailLarge];
    } else {
        m_postLabel.text = @"";
        m_postImageView.URL = nil;
    }
}

- (NSInteger)indexOfSelectedItem
{
    if(m_selectedPost) {
        for(NSInteger i = 0, c = m_posts.count; i < c; i++) {
            MFPost *post = [m_posts objectAtIndex:i];
            
            if(post == m_selectedPost || [post.identifier isEqualToString:m_selectedPost.identifier]) {
                return i;
            }
        }
    }
    
    return NSNotFound;
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

- (IBAction)prev:(id)sender
{
    if(m_selectedPost) {
        NSInteger index = [self indexOfSelectedItem];
        
        if(index != NSNotFound) {
            m_selectedPost = [m_posts objectAtIndex:(index > 0) ? index - 1 : m_posts.count - 1];
            [self invalidatePost];
        }
    }
}

- (IBAction)next:(id)sender
{
    if(m_selectedPost) {
        NSInteger index = [self indexOfSelectedItem];
        
        if(index != NSNotFound) {
            m_selectedPost = [m_posts objectAtIndex:(index + 1 < m_posts.count) ? index + 1 : 0];
            [self invalidatePost];
        }
    }
}

@synthesize delegate = m_delegate;

@dynamic posts;

- (NSArray *)posts
{
    return m_posts;
}

- (void)setPosts:(NSArray *)posts
{
    if(m_posts != posts) {
        m_posts = posts;
        
        if(m_posts.count > 1) {
            m_prevButton.hidden = NO;
            m_nextButton.hidden = NO;
        } else {
            m_prevButton.hidden = YES;
            m_nextButton.hidden = YES;
        }
        
        [self invalidatePost];
    }
}

@synthesize selectedPost = m_selectedPost;

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        UIButton *shopByColorButton = [MFImageButton themeButtonWithFrame:CGRectMake(10.0F, 194.0F, 160.0F, 49.0F)];
        UIButton *shopByDressButton = [MFImageButton themeButtonWithFrame:CGRectMake(160.0F, 194.0F, 150.0F, 49.0F)];
        UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 194.0F, frame.size.width, 1.0F)];
        UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, frame.size.height - 1.0F, frame.size.width, 1.0F)];
        UIButton *shopByFeaturedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        topSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        topSeparatorView.backgroundColor = [UIColor themeSeparatorTopColor];
        [self addSubview:topSeparatorView];
        
        bottomSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        bottomSeparatorView.backgroundColor = [UIColor themeSeparatorBottomColor];
        [self addSubview:bottomSeparatorView];
        
        m_prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        m_prevButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        m_prevButton.frame = CGRectMake(0.0F, 0.0F, 40.0F, 48.0F);
        m_prevButton.center = CGPointMake(20.0F, 91.0F);
        m_prevButton.hidden = YES;
        [m_prevButton addTarget:self action:@selector(prev:) forControlEvents:UIControlEventTouchUpInside];
        [m_prevButton setImage:[UIImage imageNamed:@"Prev-Indicator.png"] forState:UIControlStateNormal];
        [self addSubview:m_prevButton];
        
        m_nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        m_nextButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        m_nextButton.frame = CGRectMake(0.0F, 0.0F, 40.0F, 48.0F);
        m_nextButton.center = CGPointMake(frame.size.width - 20.0F, 91.0F);
        m_nextButton.hidden = YES;
        [m_nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        [m_nextButton setImage:[UIImage imageNamed:@"Next-Indicator.png"] forState:UIControlStateNormal];
        [self addSubview:m_nextButton];
        
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
        
        m_postLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0F, 162.0F, 300.0F, 31.0F)];
        m_postLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        m_postLabel.backgroundColor = [UIColor clearColor];
        m_postLabel.font = [UIFont themeFontOfSize:12.0F];
        m_postLabel.textAlignment = NSTextAlignmentCenter;
        m_postLabel.numberOfLines = 0;
        [self addSubview:m_postLabel];
        
        m_postImageView = [[MFImageView alloc] initWithFrame:CGRectMake(78.0F, 9.0F, 164.0F, 152.0F)];
        m_postImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        m_postImageView.layer.borderColor = [UIColor themeImageBorderColor].CGColor;
        m_postImageView.layer.borderWidth = 1.0F;
        m_postImageView.placeholderImage = [UIImage imageNamed:@"Home-Featured-Placeholder.png"];
        [self addSubview:m_postImageView];
        
        shopByFeaturedButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        shopByFeaturedButton.frame = CGRectMake(78.0F, 9.0F, 164.0F, 152.0F);
        [shopByFeaturedButton addTarget:self action:@selector(shopByFeatured:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shopByFeaturedButton];
    }
    
    return self;
}

@end
