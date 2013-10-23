/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequestTransform.h"

@class MFMoney, MFUserDetails;

@interface MFCheckout : NSObject <MFWebRequestTransform>
{
    @private
    MFUserDetails *m_user;
    NSDictionary *m_fees;
    NSArray *m_posts;
    NSArray *m_countries;
    NSArray *m_deliveries;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

- (MFMoney *)feeForCurrency:(NSString *)currency;
@property (nonatomic, retain, readonly) NSArray *countries;
@property (nonatomic, retain, readonly) NSArray *deliveries;
@property (nonatomic, retain, readonly) NSArray *posts;
@property (nonatomic, retain, readonly) MFUserDetails *user;

@end
