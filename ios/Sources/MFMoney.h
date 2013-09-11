/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFMoney : NSObject
{
    @private
    NSInteger m_value;
    NSString *m_currency;
}

- (id)initWithValue:(NSInteger)value currency:(NSString *)currency;

@property (nonatomic, assign, readonly) NSInteger value;
@property (nonatomic, retain, readonly) NSString *currency;
@property (nonatomic, retain, readonly) NSString *stringValue;

@end
