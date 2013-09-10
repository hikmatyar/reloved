/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface NSDictionary(Additions)

- (NSArray *)arrayForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;
- (NSString *)identifierForKey:(id)key;
- (NSInteger)integerForKey:(id)key;
- (NSNumber *)numberForKey:(id)key;
- (NSString *)stringForKey:(id)key;
- (NSTimeInterval)timeIntervalForKey:(id)key;

@end
