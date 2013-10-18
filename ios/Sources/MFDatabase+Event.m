/* Copyright (c) 2013 Meep Factory OU */

#import "JSONKit.h"
#import "MFDatabase+Event.h"
#import "MFEvent.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangeEventsNotification = @"MFDatabaseDidChangeEvents";
NSString *MFDatabaseDidChangeUnreadEventsNotification = @"MFDatabaseDidChangeUnreadEvents";

#define IDENTIFIER_UNREAD @"unread"
#define EVENT_EXPIRES 24.0F * 60.0F * 60.0F * 7.0F
#define TABLE_EVENTS @"events"
#define TABLE_EVENTS_FEED @"events_feed"

@implementation MFDatabase(Event)

+ (NSTimeInterval)eventExpires
{
    return EVENT_EXPIRES;
}

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
        NSTimeInterval expires = [NSDate timeIntervalSinceReferenceDate] + [self.class eventExpires];
        
        [m_state setValue:events forKey:TABLE_EVENTS];
        [m_state removeObjectForKey:TABLE_EVENTS_FEED];
        [m_store removeAllObjectsInTable:TABLE_EVENTS];
        
        for(MFEvent *event in events) {
            [m_store setObject:[event.attributes JSONData] expires:expires forKey:event.identifier inTable:TABLE_EVENTS];
        }
        
        [self addUpdate:MFDatabaseDidChangeEventsNotification change:nil];
    }
}

- (void)addEvents:(NSArray *)events
{
    if(events.count > 0) {
        NSTimeInterval expires = [NSDate timeIntervalSinceReferenceDate] + [self.class eventExpires];
        
        [m_state removeObjectForKey:TABLE_EVENTS];
        [m_state removeObjectForKey:TABLE_EVENTS_FEED];
        
        for(MFEvent *event in events) {
            [m_store setObject:[event.attributes JSONData] expires:expires forKey:event.identifier inTable:TABLE_EVENTS];
            [self markEventAsUnread:event];
        }
        
        [self addUpdate:MFDatabaseDidChangeEventsNotification change:nil];
    }
}

@dynamic unreadEvents;

- (NSArray *)unreadEvents
{
    NSArray *s_events = [m_state objectForKey:TABLE_EVENTS_FEED];
    
    if(!s_events) {
        NSMutableArray *events = [[NSMutableArray alloc] init];
        
        for(MFEvent *event in [m_store associationsForKey:IDENTIFIER_UNREAD inTable:TABLE_EVENTS_FEED forTable:TABLE_EVENTS usingBlock:^id (NSString *key, NSData *value) {
            return [[MFEvent alloc] initWithAttributes:[value objectFromJSONData]];
        }].objectEnumerator) {
            [events addObject:event];
        }
        
        [m_state setObject:events forKey:TABLE_EVENTS_FEED];
        s_events = events;
    }
    
    return s_events;
}

- (void)setUnreadEvents:(NSArray *)unreadEvents
{
    if(!unreadEvents || [m_state objectForKey:TABLE_EVENTS_FEED] != unreadEvents) {
        [m_state removeObjectForKey:TABLE_EVENTS_FEED];
        [m_store removeAllObjectsInTable:TABLE_EVENTS_FEED];
        
        for(MFEvent *event in unreadEvents) {
            [m_store associateKey:IDENTIFIER_UNREAD inTable:TABLE_EVENTS_FEED withKey:event.identifier inTable:TABLE_EVENTS];
        }
        
        [self addUpdate:MFDatabaseDidChangeUnreadEventsNotification change:nil];
    }
}

- (void)markEventAsRead:(MFEvent *)event
{
    if(event) {
        [m_state removeObjectForKey:TABLE_EVENTS_FEED];
        [m_store dissociateKey:IDENTIFIER_UNREAD inTable:TABLE_EVENTS_FEED withKey:event.identifier inTable:TABLE_EVENTS];
        [self addUpdate:MFDatabaseDidChangeUnreadEventsNotification change:event];
    }
}

- (void)markEventAsUnread:(MFEvent *)event
{
    if(event) {
        [m_state removeObjectForKey:TABLE_EVENTS_FEED];
        [m_store associateKey:IDENTIFIER_UNREAD inTable:TABLE_EVENTS_FEED withKey:event.identifier inTable:TABLE_EVENTS];
        [self addUpdate:MFDatabaseDidChangeUnreadEventsNotification change:event];
    }
}

@end