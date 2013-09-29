/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

extern NSString *MFDatabaseChangesKey;
extern NSString *MFDatabaseDidChangeNotification;

@interface MFDatabase : NSObject
{
    @private
}

+ (MFDatabase *)sharedDatabase;

- (void)invalidateObjects;
- (void)removeAllObjects;
- (void)beginUpdates;
- (void)endUpdates;

@end
