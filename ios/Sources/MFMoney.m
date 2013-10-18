/* Copyright (c) 2013 Meep Factory OU */

#import "MFMoney.h"

@implementation MFMoney

- (id)initWithLocalizedString:(NSString *)str currency:(NSString *)currency
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number;
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    number = [formatter numberFromString:str];
    
    return [self initWithValue:round(number.doubleValue * 100.0) currency:currency];
}

- (id)initWithValue:(NSInteger)value currency:(NSString *)currency
{
    self = [super init];
    
    if(self) {
        m_value = value;
        m_currency = currency;
    }
    
    return self;
}

@synthesize value = m_value;
@synthesize currency = m_currency;

@dynamic localizedString;

- (NSString *)localizedString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *value;
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    value = [formatter stringFromNumber:[NSNumber numberWithDouble:(double)m_value / 100.0]];
    
    if([m_currency isEqualToString:@"GBP"]) {
        value = [NSLocalizedString(@"Currency.GBP", nil) stringByAppendingString:value];
    }
    
    return value;
}

@dynamic stringValue;

- (NSString *)stringValue
{
    return (m_value > 10000) ?
        [NSString stringWithFormat:@"%@ %d.-", (m_currency) ? m_currency : @"", (NSInteger)round((double)m_value / 100.0)] :
        [NSString stringWithFormat:@"%@ %g.-", (m_currency) ? m_currency : @"", ((double)m_value / 100.0)];
}

@end
