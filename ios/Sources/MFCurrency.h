/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFCurrency : NSObject
{
    @private
    NSString *m_identifier;
    NSString *m_code;
    NSString *m_country;
    BOOL m_fallback;
}

- (id)initWithAttributes:(NSDictionary *)attributes;
- (id)initWithIdentifier:(NSString *)identifier code:(NSString *)code country:(NSString *)country fallback:(BOOL)fallback;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, retain, readonly) NSString *code;
@property (nonatomic, retain, readonly) NSString *country;
@property (nonatomic, assign, readonly, getter = isFallback) BOOL fallback;
@property (nonatomic, retain, readonly) NSString *identifier;

@end
