/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@interface MFDatabase(State)

@property (nonatomic, retain) NSString *globalState;
@property (nonatomic, retain) NSURL *globalPrefix;

- (NSURL *)URLForString:(NSString *)str;

@end
