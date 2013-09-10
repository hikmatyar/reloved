/* Copyright (c) 2013 Meep Factory OU */

#import "NSDictionary+Additions.h"

@implementation NSDictionary(Additions)

- (NSArray *)arrayForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    return ([obj isKindOfClass:[NSArray class]]) ? (NSArray *)obj : nil;
}

- (NSDictionary *)dictionaryForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    return ([obj isKindOfClass:[NSDictionary class]]) ? (NSDictionary *)obj : nil;
}

- (NSString *)identifierForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    if([obj isKindOfClass:[NSNumber class]]) {
        obj = ((NSNumber *)obj).stringValue;
    }
    
    return ([obj isKindOfClass:[NSString class]]) ? (NSString *)obj : nil;
}

- (NSInteger)integerForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    return ([obj respondsToSelector:@selector(integerValue)]) ? ((NSNumber *)obj).integerValue : 0;
}

- (NSNumber *)numberForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    return ([obj isKindOfClass:[NSNumber class]]) ? (NSNumber *)obj : nil;
}

- (NSString *)stringForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    return ([obj isKindOfClass:[NSString class]]) ? (NSString *)obj : nil;
}

- (NSTimeInterval)timeIntervalForKey:(id)key
{
	id obj = [self objectForKey:key];
	
	return ([obj isKindOfClass:[NSNumber class]]) ? ((NSNumber *)obj).doubleValue : 0.0F;
}

@end
