/* Copyright (c) 2013 Meep Factory OU */

#import "MFTableViewCell.h"

@class MFEvent;

@interface MFEventTableViewCell : MFTableViewCell
{
    @private
    MFEvent *m_event;
}

@property (nonatomic, retain) MFEvent *event;

@end
