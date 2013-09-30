/* Copyright (c) 2013 Meep Factory OU */

#import "MFPost.h"
#import "MFPostTableViewCell.h"
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
        
        [str beginEditing];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"GUCCI\n" attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeBoldFontOfSize:14.0F], NSFontAttributeName, nil]]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"'Black lether dress'\n" attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeFontOfSize:14.0F], NSFontAttributeName, nil]]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@" 150 " attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:
                //[NSNumber numberWithInteger:NSUnderlineStyleThick], NSStrikethroughStyleAttributeName,
                [UIColor themeTextAlternativeColor], NSForegroundColorAttributeName, nil]]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@" 90\n" attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:
                [UIFont themeBoldFontOfSize:14.0F], NSFontAttributeName,
                [UIColor blueColor], NSForegroundColorAttributeName, nil]]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"----------------\n" attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeFontOfSize:12.0F], NSFontAttributeName, nil]]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"A luxurious look for a special night out. Simple, elegant and just right for a summer\n" attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeFontOfSize:14.0F], NSFontAttributeName, nil]]];
        [str endEditing];
        
        m_post = post;
        self.textLabel.attributedText = str;
    }
}

#pragma mark UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        UILabel *textLabel = self.textLabel;
        
        textLabel.layer.borderColor = [UIColor themeSeparatorColor].CGColor;
        textLabel.layer.borderWidth = 1.0F;
        textLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        textLabel.backgroundColor = [UIColor lightGrayColor];
        textLabel.font = [UIFont themeFontOfSize:14.0F];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 0;
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
