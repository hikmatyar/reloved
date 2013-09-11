/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFWebSession : NSObject
{
    @private
    NSTimeInterval m_timestamp;
    NSString *m_identifier;
    NSString *m_userId;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;
@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, retain, readonly) NSString *userId;

@end
