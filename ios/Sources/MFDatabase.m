/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

NSString *MFDatabaseChangesKey = @"changes";
NSString *MFDatabaseDidChangeNotification = @"MFDatabaseDidChange";

@implementation MFDatabase

+ (MFDatabase *)sharedDatabase
{
    __strong static MFDatabase *sharedDatabase = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        sharedDatabase = [[self alloc] init];
    });
    
    return sharedDatabase;
}

- (void)invalidateObjects
{
}

- (void)removeAllObjects
{
}

- (void)beginUpdates
{
}

- (void)endUpdates
{
}

#pragma mark NSObject

@end
