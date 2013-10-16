/* Copyright (c) 2013 Meep Factory OU */

#import "MFConditionTableViewCell.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define SIDE_PADDING 17.0F
#define TEXT_HEIGHT 44.0F
#define COMMENT_HEIGHT 20.0F

@implementation MFConditionTableViewCell

+ (CGFloat)preferredHeight
{
    return 153.0F;
}

@dynamic text;

- (NSString *)text
{
    return m_text;
}

- (void)setText:(NSString *)text
{
    self.textLabel.text = text;
}

@dynamic comments;

- (NSArray *)comments
{
    return m_comments;
}

- (void)setComments:(NSArray *)comments
{
    if(!MFEqual(m_comments, comments)) {
        CGRect frame = m_commentsView.bounds;
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, 1.0F)];
        CGFloat offset = SIDE_PADDING;
        
        m_comments = comments;
        
        for(UIView *view in m_commentsView.subviews) {
            [view removeFromSuperview];
        }
        
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        separatorView.backgroundColor = [UIColor themeSeparatorColor];
        [m_commentsView addSubview:separatorView];
        
        for(NSString *comment in m_comments) {
            UIImageView *dotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PADDING, offset + roundf(0.5F * (COMMENT_HEIGHT - 16.0F)), 16.0F, 16.0F)];
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PADDING + 20.0F, offset, frame.size.width - 20.0F - SIDE_PADDING, COMMENT_HEIGHT)];
            
            dotImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            dotImageView.image = [UIImage imageNamed:@"Blue-Dot.png"];
            [m_commentsView addSubview:dotImageView];
            textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
            textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            textLabel.font = [UIFont themeFontOfSize:13.0F];
            textLabel.numberOfLines = 0;
            textLabel.text = comment;
            textLabel.textColor = [UIColor themeTextColor];
            [m_commentsView addSubview:textLabel];
            
            offset += COMMENT_HEIGHT;
        }
    }
}

#pragma mark UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    if(self) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]];
        self.accessoryView.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont themeBoldFontOfSize:20.0F];
        self.textLabel.textColor = [UIColor themeTextColor];
        
        m_commentsView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 100.0F)];
        m_commentsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:m_commentsView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	self.accessoryView.hidden = !selected;
	[super setSelected:selected animated:animated];
}

#pragma mark UIView

- (void)layoutSubviews
{
    CGRect frame = self.bounds;
    
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(SIDE_PADDING, 0.0F, frame.size.width - 2.0F * SIDE_PADDING - 32.0F, TEXT_HEIGHT);
    self.accessoryView.frame = CGRectMake(frame.size.width - 40.0F, roundf(0.5F * (TEXT_HEIGHT - 32.0F)), 32.0F, 32.0F);
    frame.origin.y += TEXT_HEIGHT;
    frame.size.height -= TEXT_HEIGHT;
    m_commentsView.frame = frame;
}

@end
