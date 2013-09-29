/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

extern NSString *MFDatabaseChangesKey;
extern NSString *MFDatabaseDidChangeNotification;

@class SQLObjectStore;

@interface MFDatabase : NSObject
{
    @private
    NSMutableDictionary *m_changes;
    NSInteger m_changeCount;
    NSMutableSet *m_proxies;
    SQLObjectStore *m_store;
    NSMutableDictionary *m_state;
}

+ (MFDatabase *)sharedDatabase;

@property (nonatomic, retain, readonly) NSMutableDictionary *state;
@property (nonatomic, retain, readonly) SQLObjectStore *store;

- (void)invalidateObjects;
- (void)removeAllObjects;

- (void)beginUpdates;
- (void)addUpdate:(NSString *)name change:(id)change;
- (void)addUpdate:(NSString *)name changes:(NSSet *)changes;
- (void)endUpdates;

@end
