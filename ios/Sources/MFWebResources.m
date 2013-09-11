/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebResources.h"
#import "MFWebService.h"

@implementation MFWebResources

- (id)initWithService:(MFWebService *)service
{
    self = [super init];
    
    if(self) {
        m_service = service;
    }
    
    return self;
}

@synthesize service = m_service;

@end
