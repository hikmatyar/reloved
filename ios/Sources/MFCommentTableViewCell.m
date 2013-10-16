/* Copyright (c) 2013 Meep Factory OU */

#import "MFComment.h"
#import "MFCommentTableViewCell.h"

@implementation MFCommentTableViewCell

@dynamic comment;

- (MFComment *)comment
{
    return m_comment;
}

- (void)setComment:(MFComment *)comment
{
    if(m_comment != comment) {
        m_comment = comment;
    }
}

@end
