/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFEvent;

extern NSString *MFDatabaseDidChangeEventsNotification;

@interface MFDatabase(Event)

@property (nonatomic, copy) NSArray *events;
- (void)addEvents:(NSArray *)events;

@end
