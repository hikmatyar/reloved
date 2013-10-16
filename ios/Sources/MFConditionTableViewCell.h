/* Copyright (c) 2013 Meep Factory OU */

#import "MFTableViewCell.h"

@interface MFConditionTableViewCell : MFTableViewCell
{
    @private
    NSString *m_text;
    NSArray *m_comments;
    UIView *m_commentsView;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSArray *comments;

@end
