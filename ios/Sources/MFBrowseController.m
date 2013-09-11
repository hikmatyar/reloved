/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrowseController.h"

@implementation MFBrowseController

- (id)initWithScope:(MFBrowseControllerScope)scope
{
    self = [super init];
    
    if(self) {
        m_scope = scope;
    }
    
    return self;
}

@dynamic scope;

- (MFBrowseControllerScope)scope
{
    return m_scope;
}

- (void)setScope:(MFBrowseControllerScope)scope
{
    if(m_scope != scope) {
        m_scope = scope;
    }
}

@end
