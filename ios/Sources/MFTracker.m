/* Copyright (c) 2013 Meep Factory OU */

#import <GAI.h>
#import "MFTracker.h"

@implementation MFTracker

+ (MFTracker *)sharedTracker
{
    __strong static MFTracker *sharedTracker = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        sharedTracker = [[self alloc] init];
    });
    
    return sharedTracker;
}

- (BOOL)logView:(NSString *)screen
{
    return [m_ga sendView:screen];
}

- (BOOL)logEventWithCategory:(NSString *)category
                  withAction:(NSString *)action
                   withLabel:(NSString *)label
                   withValue:(NSNumber *)value;
{
    return [m_ga sendEventWithCategory:category withAction:action withLabel:label withValue:value];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        GAI *gai = [GAI sharedInstance];
        
#ifdef DEBUG
        gai.debug = YES;
#endif
        gai.dispatchInterval = 120;
        gai.trackUncaughtExceptions = YES;
        
        m_ga = [gai trackerWithTrackingId:GOOGLE_ANALYTICS];
    }
    
    return self;
}

@end

#pragma mark -

void MFLogEvent(NSString *category, NSString *action, NSString *label, int value) {
    [[MFTracker sharedTracker] logEventWithCategory:category withAction:action withLabel:label withValue:(value != 0) ? [NSNumber numberWithInteger:value] : nil];
}

void MFLogView(NSString *screen) {
    [[MFTracker sharedTracker] logView:screen];
}