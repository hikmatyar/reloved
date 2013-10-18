/* Copyright (c) 2013 Meep Factory OU */

#import "MFEvent.h"
#import "MFEventTableViewCell.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

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

#pragma mark UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        self.backgroundNormalColor = [UIColor themeButtonBackgroundColor];
        self.backgroundHighlightColor = [UIColor themeButtonBackgroundHighlightColor];
    }
    
    return self;
}

@end
