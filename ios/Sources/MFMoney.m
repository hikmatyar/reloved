/* Copyright (c) 2013 Meep Factory OU */

#import "MFMoney.h"

@implementation MFMoney

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

@dynamic stringValue;

- (NSString *)stringValue
{
    return (m_value > 10000) ?
        [NSString stringWithFormat:@"%@ %d.-", (m_currency) ? m_currency : @"", (NSInteger)round((double)m_value / 100.0F)] :
        [NSString stringWithFormat:@"%@ %g.-", (m_currency) ? m_currency : @"", ((double)m_value / 100.0F)];
}

@end
