/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFDelivery : NSObject
{
    @private
    NSString *m_identifier;
    NSString *m_name;
    NSInteger m_price;
    NSString *m_currency;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSInteger price;
@property (nonatomic, retain, readonly) NSString *currency;

@end
