/* Copyright (c) 2013 Meep Factory OU */

#import "MFMenuItem.h"

@implementation MFMenuItem

- (id)initWithTitle:(NSString *)title image:(NSString *)image selector:(SEL)selector
{
    self = [super init];
    
    if(self) {
        m_image = image;
        m_selector = selector;
        m_title = title;
    }
    
    return self;
}

@synthesize image = m_image;
@synthesize selector = m_selector;
@synthesize title = m_title;

- (void)activate:(id)target
{
    MFMenuItemAction imp = (MFMenuItemAction)[target methodForSelector:m_selector];
    
    if(imp != NULL) {
        imp(target, m_selector, self);
    }
}

@end
