/* Copyright (c) 2013 Meep Factory OU */

#import "MFMenu.h"

@implementation MFMenu

- (id)initWithTitle:(NSString *)title children:(NSArray *)children
{
    self = [super init];
    
    if(self) {
        m_title = title;
        m_children = children;
    }
    
    return self;
}

@synthesize title = m_title;
@synthesize children = m_children;

@dynamic count;

- (NSInteger)count
{
    return m_children.count;
}

- (MFMenuItem *)objectAtIndex:(NSInteger)index
{
    return [m_children objectAtIndex:index];
}

@end
