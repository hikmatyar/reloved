/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrand.h"
#import "MFDatabase+Brand.h"
#import "MFDatabase+Size.h"
#import "MFDatabase+State.h"
#import "MFMoney.h"
#import "MFPost.h"
#import "MFPostEditableTableViewCell.h"
#import "MFSize.h"
#import "MFType.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFPostEditableTableViewCell

+ (CGFloat)preferredHeight
{
    return 130.0F;
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
        NSString *size = [database sizeForIdentifier:post.sizeId].localizedName;
        MFMoney *price = [[MFMoney alloc] initWithValue:post.price currency:post.currency];
        NSString *title = post.title;
        NSURL *oldURL = [database URLForMedia:m_post.mediaIds.firstObject size:kMFMediaSizeThumbnailSmall];
        NSURL *newURL = [database URLForMedia:post.mediaIds.firstObject size:kMFMediaSizeThumbnailSmall];
        
        if(post.status == kMFPostStatusListed) {
            self.textLabel.textColor = [UIColor themeTextColor];
            self.detailTextLabel.textColor = [UIColor themeTextColor];
        } else {
            self.textLabel.textColor = [UIColor themeTextDisabledColor];
            self.detailTextLabel.textColor = [UIColor themeTextDisabledColor];
        }
        
        if(!oldURL || !MFEqual(oldURL, newURL)) {
            self.imageView.image = nil;
            self.imageView.tag = -1;
        }
        
        [str beginEditing];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", brand] attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeBoldFontOfSize:14.0F], NSFontAttributeName, nil]]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", title] attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeFontOfSize:12.0F], NSFontAttributeName, nil]]];
        [str endEditing];
        self.textLabel.attributedText = str;
        
        str = [[NSMutableAttributedString alloc] init];
        [str beginEditing];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", price.localizedString] attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeBoldFontOfSize:14.0F], NSFontAttributeName, nil]]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", size] attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeFontOfSize:12.0F], NSFontAttributeName, nil]]];
        [str endEditing];
        self.detailTextLabel.attributedText = str;
        
        m_post = post;
        
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
        NSURL *URL = [[MFDatabase sharedDatabase] URLForMedia:m_post.mediaIds.firstObject size:kMFMediaSizeThumbnailSmall];
        
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
            imageView.image = [UIImage imageNamed:@"Thumbnail-Placeholder.png"];
        }
    }
}

#pragma mark UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    if(self) {
        UIImageView *imageView = self.imageView;
        UILabel *textLabel = self.textLabel;
        UILabel *detailTextLabel = self.detailTextLabel;
        
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = NO;
        
        textLabel.font = [UIFont themeFontOfSize:14.0F];
        textLabel.numberOfLines = 0;
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.textColor = [UIColor themeTextColor];
        
        detailTextLabel.font = [UIFont themeFontOfSize:14.0F];
        detailTextLabel.numberOfLines = 0;
        detailTextLabel.textColor = [UIColor themeTextColor];
        detailTextLabel.textAlignment = NSTextAlignmentLeft;
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Disclosure-Indicator.png"]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundNormalColor = [UIColor themeButtonBackgroundColor];
        self.backgroundHighlightColor = [UIColor themeButtonBackgroundHighlightColor];
    }
    
    return self;
}

@end
