/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"
#import "MFDatabaseProxy.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseChangesKey = @"changes";
NSString *MFDatabaseDidChangeNotification = @"MFDatabaseDidChange";

@interface MFDatabase(Private)

- (void)attach_proxy_feeds;
- (void)attach_proxy_posts;

@end

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

- (void)addUpdate:(NSString *)name change:(id)change
{
    NSMutableSet *changes;
    
    if(!m_changes) {
        m_changes = [[NSMutableDictionary alloc] init];
    }
    
    changes = [m_changes objectForKey:name];
    
    if(!changes) {
        changes = [NSMutableSet set];
        [m_changes setObject:changes forKey:name];
    }
    
    if(change) {
        [changes addObject:change];
    }
    
    if(m_changeCount == 0) {
        m_changeCount += 1;
        [self endUpdates];
    }
}

- (void)addUpdate:(NSString *)name changes:(NSSet *)_changes
{
    NSMutableSet *changes;
    
    if(!m_changes) {
        m_changes = [[NSMutableDictionary alloc] init];
    }
    
    changes = [m_changes objectForKey:name];
    
    if(!changes) {
        changes = [NSMutableSet set];
        [m_changes setObject:changes forKey:name];
    }
    
    if(_changes) {
        for(id change in _changes) {
            [changes addObject:change];
        }
    }
    
    if(m_changeCount == 0) {
        m_changeCount += 1;
        [self endUpdates];
    }
}

- (void)invalidateObjects
{
    [self beginUpdates];
    
    for(MFDatabaseProxy *proxy in m_proxies) {
        [proxy invalidateObjects];
    }
    
    [self endUpdates];
}

- (void)removeAllObjects
{
    [m_store removeAllObjects];
}

- (void)beginUpdates
{
    m_changeCount += 1;
}

- (void)endUpdates
{
    m_changeCount -= 1;
    
    if(m_changeCount == 0) {
        if(m_changes.count > 0) {
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            NSMutableDictionary *changes = m_changes;
            
            m_changes = nil;
            
            for(NSString *change in changes.keyEnumerator) {
                [notificationCenter postNotificationName:change
                                                  object:self
                                                userInfo:[NSDictionary dictionaryWithObject:[changes objectForKey:change]
                                                                                     forKey:MFDatabaseChangesKey]];
            }
            
            [notificationCenter postNotificationName:MFDatabaseDidChangeNotification object:self];
            
            if(!m_changes) {
                [changes removeAllObjects];
                m_changes = changes;
            }
        }
    } else if(m_changeCount < 0) {
        MFError(@"Unbalanced updates");
    }
}

@synthesize state = m_state;
@synthesize store = m_store;

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        m_proxies = [[NSMutableSet alloc] init];
        m_state = [[NSMutableDictionary alloc] init];
        m_store = [[SQLObjectStore alloc] initWithPath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"main.db"]
                                                  mode:kSQLObjectStoreModeFirstExpires];
        
        [self attach_proxy_feeds];
        [self attach_proxy_posts];
    }
    
    return self;
}

@end
