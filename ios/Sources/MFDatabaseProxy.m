/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabaseProxy.h"

@implementation MFDatabaseProxy

- (id)initWithDatabase:(MFDatabase *)database
{
    self = [super init];
    
    if(self) {
        m_database = database;
    }
    
    return self;
}

- (void)invalidateObjects
{
}

@end
