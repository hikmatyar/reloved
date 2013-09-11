/* Copyright (c) 2013 Meep Factory OU */

#import "MFHomeFooterView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFHomeFooterView

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0F, 10.0F, 300.0F, 25.0F)];
        UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0F, 50.0F, 300.0F, 25.0F)];
        UIImageView *checkmarkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home-Checkmark"]];
        CGSize footerSize;
        
        footerLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        footerLabel.font = [UIFont themeFontOfSize:14.0F];
        footerLabel.text = NSLocalizedString(@"Home.Label.Footer", nil);
        footerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:footerLabel];
        
        footerSize = [footerLabel sizeThatFits:CGSizeMake(300.0F, 25.0F)];
        checkmarkImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        checkmarkImageView.frame = CGRectMake(roundf(0.5F * (320.0F - footerSize.width)) - 32.0F, 10.0F, 25.0F, 25.0F);
        [self addSubview:checkmarkImageView];
        
        copyrightLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        copyrightLabel.font = [UIFont themeBoldFontOfSize:14.0F];
        copyrightLabel.text = NSLocalizedString(@"Home.Label.Copyright", nil);
        copyrightLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:copyrightLabel];
    }
    
    return self;
}

@end
