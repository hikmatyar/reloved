/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@protocol MFWebRequestTransform <NSObject>

@required

+ (id)parseFromObject:(id)object;

@end
