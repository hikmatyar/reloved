/* Copyright (c) 2013 Meep Factory OU */

#import "MFPreferences.h"

@implementation MFPreferences

+ (MFPreferences *)sharedPreferences
{
    __strong static MFPreferences *sharedPreferences = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        sharedPreferences = [[self alloc] init];
    });
    
    return sharedPreferences;
}

@end
