/* Copyright (c) 2013 Meep Factory OU */

#import "MFMenuItem.h"

@implementation MFMenuItem

- (id)initWithTitle:(NSString *)title selector:(SEL)selector image:(NSString *)image
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

@end
