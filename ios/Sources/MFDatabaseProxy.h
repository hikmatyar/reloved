/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFDatabase;

@interface MFDatabaseProxy : NSObject
{
    @protected
    __unsafe_unretained MFDatabase *m_database;
}

- (id)initWithDatabase:(MFDatabase *)database;

- (void)invalidateObjects;

@end
