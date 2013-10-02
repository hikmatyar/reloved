/* Copyright (c) 2013 Meep Factory OU */

#import "MFNewPostConditionTableViewCell.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFNewPostConditionTableViewCell

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
}

#pragma mark UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
    
    }
    
    return self;
}

@end
