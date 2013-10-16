/* Copyright (c) 2013 Meep Factory OU */

#import "MFTableViewCell.h"

@class MFComment;

@interface MFCommentTableViewCell : MFTableViewCell
{
    @private
    MFComment *m_comment;
}

@property (nonatomic, retain) MFComment *comment;

@end
