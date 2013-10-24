/* Copyright (c) 2013 Meep Factory OU */

#import "MFCart.h"

#define KEY_DELIVERY @"delivery"
#define KEY_STRIPE @"stripe"
#define KEY_PRICE @"price"
#define KEY_AMOUNT @"amount"
#define KEY_TRANSACTION_FEE @"fee"
#define KEY_CURRENCY @"currency"
#define KEY_EMAIL @"email"
#define KEY_PHONE @"phone"
#define KEY_FIRST_NAME @"first_name"
#define KEY_LAST_NAME @"last_name"
#define KEY_COUNTRY @"country"
#define KEY_CITY @"city"
#define KEY_ADDRESS @"address"
#define KEY_ZIPCODE @"zipcode"
#define KEY_POSTS @"ids"

@implementation MFCart

@dynamic attributes;

- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setValue:m_deliveryId forKey:KEY_DELIVERY];
    [attributes setValue:m_stripeToken forKey:KEY_STRIPE];
    [attributes setValue:[NSNumber numberWithInteger:m_price] forKey:KEY_PRICE];
    [attributes setValue:[NSNumber numberWithInteger:m_amount] forKey:KEY_AMOUNT];
    [attributes setValue:[NSNumber numberWithInteger:m_transactionFee] forKey:KEY_TRANSACTION_FEE];
    [attributes setValue:m_currency forKey:KEY_CURRENCY];
    [attributes setValue:m_email forKey:KEY_EMAIL];
    [attributes setValue:m_phone forKey:KEY_PHONE];
    [attributes setValue:m_firstName forKey:KEY_FIRST_NAME];
    [attributes setValue:m_lastName forKey:KEY_LAST_NAME];
    [attributes setValue:m_countryId forKey:KEY_COUNTRY];
    [attributes setValue:m_city forKey:KEY_CITY];
    [attributes setValue:m_address forKey:KEY_ADDRESS];
    [attributes setValue:m_zipcode forKey:KEY_ZIPCODE];
    [attributes setValue:m_postIds forKey:KEY_POSTS];
    
    return attributes;
}

@dynamic empty;

- (BOOL)isEmpty
{
    return (!m_currency || m_postIds.count == 0) ? YES : NO;
}

@dynamic fullName;

- (NSString *)fullName
{
    return (m_firstName.length > 0 && m_lastName.length > 0) ? [NSString stringWithFormat:@"%@ %@", m_firstName, m_lastName] : ((m_firstName.length > 0) ? m_firstName : m_lastName);
}

@synthesize postIds = m_postIds;
@synthesize email = m_email;
@synthesize phone = m_phone;
@synthesize deliveryId = m_deliveryId;
@synthesize price = m_price;
@synthesize amount = m_amount;
@synthesize transactionFee = m_transactionFee;
@synthesize firstName = m_firstName;
@synthesize lastName = m_lastName;
@synthesize countryId = m_countryId;
@synthesize city = m_city;
@synthesize address = m_address;
@synthesize zipcode = m_zipcode;
@synthesize stripeToken = m_stripeToken;

@end

#pragma mark -

@implementation MFMutableCart

- (void)setPostIds:(NSArray *)postIds
{
    m_postIds = postIds;
}

- (void)setDeliveryId:(NSString *)deliveryId
{
    m_deliveryId = deliveryId;
}

- (void)setCurrency:(NSString *)currency
{
    m_currency = currency;
}

- (void)setAmount:(NSInteger)amount
{
    m_amount = amount;
}

- (void)setPrice:(NSInteger)price
{
    m_price = price;
}

- (void)setTransactionFee:(NSInteger)transactionFee
{
    m_transactionFee = transactionFee;
}

- (void)setEmail:(NSString *)email
{
    m_email = email;
}

- (void)setPhone:(NSString *)phone
{
    m_phone = phone;
}

- (void)setFirstName:(NSString *)firstName
{
    m_firstName = firstName;
}

- (void)setLastName:(NSString *)lastName
{
    m_lastName = lastName;
}

- (void)setCountryId:(NSString *)countryId
{
    m_countryId = countryId;
}

- (void)setCity:(NSString *)city
{
    m_city = city;
}

- (void)setAddress:(NSString *)address
{
    m_address = address;
}

- (void)setZipcode:(NSString *)zipcode
{
    m_zipcode = zipcode;
}

- (void)setStripeToken:(NSString *)stripeToken
{
    m_stripeToken = stripeToken;
}

@end