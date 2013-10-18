/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFEvent;

extern NSString *MFDatabaseDidChangeEventsNotification;
extern NSString *MFDatabaseDidChangeUnreadEventsNotification;

@interface MFDatabase(Event)

@property (nonatomic, copy) NSArray *events;
- (void)addEvents:(NSArray *)events;

@property (nonatomic, copy) NSArray *unreadEvents;

- (void)markEventAsRead:(MFEvent *)event;
- (void)markEventAsUnread:(MFEvent *)event;

@end
