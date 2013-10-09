/* Copyright (c) 2013 Meep Factory OU */

#import "JSONKit.h"
#import "MFDatabase+Event.h"
#import "MFEvent.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangeEventsNotification = @"MFDatabaseDidChangeEvents";

#define TABLE_EVENTS @"events"

@implementation MFDatabase(Event)

@dynamic events;

- (NSArray *)events
{
    NSArray *s_events = [m_state objectForKey:TABLE_EVENTS];
    
    if(!s_events) {
        NSMutableArray *events = [[NSMutableArray alloc] init];
        
        for(MFEvent *event in [m_store allObjectsInTable:TABLE_EVENTS usingBlock:^id (NSString *key, NSData *value) {
            return [[MFEvent alloc] initWithAttributes:[value objectFromJSONData]];
        }].objectEnumerator) {
            [events addObject:event];
        }
        
        [m_state setObject:events forKey:TABLE_EVENTS];
        s_events = events;
    }
    
    return s_events;
}

- (void)setEvents:(NSArray *)events
{
    if(!events || [m_state objectForKey:TABLE_EVENTS] != events) {
        [m_state setValue:events forKey:TABLE_EVENTS];
        [m_store removeAllObjectsInTable:TABLE_EVENTS];
        
        for(MFEvent *event in events) {
            [m_store setObject:[event.attributes JSONData] forKey:event.identifier inTable:TABLE_EVENTS];
        }
        
        [self addUpdate:MFDatabaseDidChangeEventsNotification change:nil];
    }
}

- (void)addEvents:(NSArray *)events
{
    for(MFEvent *event in events) {
        [m_store setObject:[event.attributes JSONData] forKey:event.identifier inTable:TABLE_EVENTS];
    }
    
    [self addUpdate:MFDatabaseDidChangeEventsNotification change:nil];
}

@end