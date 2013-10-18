/* Copyright (c) 2013 Meep Factory OU */

#import "MFEvent.h"
#import "MFEventTableViewCell.h"

@implementation MFEventTableViewCell

@dynamic event;

- (MFEvent *)event
{
    return m_event;
}

- (void)setEvent:(MFEvent *)event
{
    if(!MFEqual(m_event, event)) {
        m_event = event;
    }
}

@end
