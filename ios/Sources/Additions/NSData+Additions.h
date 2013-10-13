/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface NSData(Additions)

- (id)initWithBase64String:(NSString *)base64;

@property (nonatomic, retain, readonly) NSString *base64String;
@property (nonatomic, retain, readonly) NSString *md5String;

@end
