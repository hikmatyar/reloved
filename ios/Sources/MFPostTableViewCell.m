/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrand.h"
#import "MFDatabase+Brand.h"
#import "MFDatabase+State.h"
#import "MFMoney.h"
#import "MFPost.h"
#import "MFPostTableViewCell.h"
#import "MFSize.h"
#import "MFType.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFPostTableViewCell

+ (CGFloat)preferredHeight
{
    return 450.0F;
}

@dynamic post;

- (MFPost *)post
{
    return m_post;
}

- (void)setPost:(MFPost *)post
{
    if(m_post != post) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
        MFDatabase *database = [MFDatabase sharedDatabase];
        NSString *brand = [database brandForIdentifier:post.brandId].name;
        MFMoney *price = [[MFMoney alloc] initWithValue:post.price currency:post.currency];
        MFMoney *priceOriginal = [[MFMoney alloc] initWithValue:post.priceOriginal currency:post.currency];
        NSString *title = post.title;
        NSString *desc = [post.notes stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        NSURL *oldURL = [database URLForMedia:(m_selectedImageIndex == 0) ? m_post.mediaIds.firstObject : [m_post.mediaIds objectAtIndex:m_selectedImageIndex] size:kMFMediaSizeThumbnailLarge];
        NSURL *newURL = [database URLForMedia:(m_selectedImageIndex == 0) ? post.mediaIds.firstObject : [m_post.mediaIds objectAtIndex:m_selectedImageIndex] size:kMFMediaSizeThumbnailLarge];
        
        if(!oldURL || !MFEqual(oldURL, newURL)) {
            self.imageView.image = nil;
            self.imageView.tag = -1;
        }
        
        [str beginEditing];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", brand] attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeBoldFontOfSize:14.0F], NSFontAttributeName, nil]]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"'%@'\n", title] attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeFontOfSize:14.0F], NSFontAttributeName, nil]]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ", priceOriginal.localizedString] attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:
                //[NSNumber numberWithInteger:NSUnderlineStyleThick], NSStrikethroughStyleAttributeName,
                [UIColor themeTextAlternativeColor], NSForegroundColorAttributeName, nil]]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@\n", price.localizedString] attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:
                [UIFont themeBoldFontOfSize:14.0F], NSFontAttributeName,
                [UIColor blueColor], NSForegroundColorAttributeName, nil]]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"----------------\n" attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeFontOfSize:12.0F], NSFontAttributeName, nil]]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", desc] attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeFontOfSize:14.0F], NSFontAttributeName, nil]]];
        [str endEditing];
        
        m_post = post;
        self.textLabel.attributedText = str;
        
        if(self.superview) {
            [self prepareForDisplay];
        }
    }
}

@dynamic selectedImageIndex;

- (NSInteger)selectedImageIndex
{
    return m_selectedImageIndex;
}

- (void)setSelectedImageIndex:(NSInteger)selectedImageIndex
{
    if(m_selectedImageIndex != selectedImageIndex) {
        m_selectedImageIndex = selectedImageIndex;
        self.imageView.image = nil;
        self.imageView.tag = -1;
        
        if(self.superview) {
            [self prepareForDisplay];
        }
    }
}

#pragma mark MFTableViewCell

- (void)prepareForDisplay
{
    UIImageView *imageView = self.imageView;
    
    if(!imageView.image || imageView.tag == -1) {
        NSURL *URL = [[MFDatabase sharedDatabase] URLForMedia:(m_selectedImageIndex == 0) ? m_post.mediaIds.firstObject : [m_post.mediaIds objectAtIndex:m_selectedImageIndex] size:kMFMediaSizeThumbnailLarge];
        
        if(URL != nil) {
            BOOL exists;
            NSError *error;
            UIImage *image = [self imageForURL:URL error:&error exists:&exists];
            
            if(image) {
                imageView.image = image;
                imageView.tag = 0;
            } else if(error) {
                MFDebug(@"%@ -> %@", URL.absoluteString, error);
                imageView.tag = 0;
            }
        }
        
        if(!imageView.image) {
            imageView.image = [UIImage imageNamed:@"Photo-Placeholder.png"];
        }
    }
}

#pragma mark UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        UIImageView *imageView = self.imageView;
        UILabel *textLabel = self.textLabel;
        
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = NO;
        
        textLabel.layer.borderColor = [UIColor themeSeparatorColor].CGColor;
        textLabel.layer.borderWidth = 1.0F;
        textLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        textLabel.backgroundColor = [UIColor lightGrayColor];
        textLabel.font = [UIFont themeFontOfSize:14.0F];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 0;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundNormalColor = [UIColor themeButtonBackgroundColor];
        self.backgroundHighlightColor = [UIColor themeButtonBackgroundHighlightColor];
    }
    
    return self;
}

#pragma mark UIView

- (void) layoutSubviews
{
    //CGRect frame = self.frame;
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.0F, 0.0F, 300.0F, 285.0F);
    self.textLabel.frame = CGRectMake(10.0F, 290.0F, 300.0F, 180.0F);
}

@end
