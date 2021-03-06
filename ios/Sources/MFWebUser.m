/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebService.h"
#import "MFWebUser.h"

@implementation MFWebUser

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
