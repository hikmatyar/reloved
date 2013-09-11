/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@protocol GAITracker;

@interface MFTracker : NSObject
{
    @private
    id <GAITracker> m_ga;
}

+ (MFTracker *)sharedTracker;

- (BOOL)logView:(NSString *)screen;
- (BOOL)logEventWithCategory:(NSString *)category withAction:(NSString *)action withLabel:(NSString *)label withValue:(NSNumber *)value;

@end
