/* Copyright (c) 2013 Meep Factory OU */

#import "MFMenuItem.h"

@implementation MFMenuItem

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(NSString *)image selector:(SEL)selector highlight:(BOOL)highlight
{
    self = [super init];
    
    if(self) {
        m_image = image;
        m_selector = selector;
        m_title = title;
        m_subtitle = subtitle;
        m_highlight = highlight;
    }
    
    return self;
}

@synthesize image = m_image;
@synthesize selector = m_selector;
@synthesize highlight = m_highlight;
@synthesize title = m_title;
@synthesize subtitle = m_subtitle;

- (void)activate:(id)target
{
    MFMenuItemAction imp = (MFMenuItemAction)[target methodForSelector:m_selector];
    
    if(imp != NULL) {
        imp(target, m_selector, self);
    }
}

@end
