/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface NSArray(Additions)

- (NSArray *)deltaWithArray:(NSArray *)array changes:(NSSet *)changes;

@end
