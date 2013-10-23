/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFCart : NSObject
{
    @protected
    NSString *m_email;
    NSString *m_phone;
    NSString *m_currency;
    NSInteger m_price;
    NSInteger m_amount;
    NSInteger m_transactionFee;
    NSString *m_deliveryId;
    NSString *m_firstName;
    NSString *m_lastName;
    NSString *m_countryId;
    NSString *m_city;
    NSString *m_address;
    NSString *m_zipcode;
    NSArray *m_postIds;
    NSString *m_stripeToken;
}

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, assign, readonly, getter = isEmpty) BOOL empty;
@property (nonatomic, retain, readonly) NSArray *postIds;
@property (nonatomic, retain, readonly) NSString *deliveryId;
@property (nonatomic, retain, readonly) NSString *currency;
@property (nonatomic, assign, readonly) NSInteger price;
@property (nonatomic, assign, readonly) NSInteger amount;
@property (nonatomic, assign, readonly) NSInteger transactionFee;
@property (nonatomic, retain, readonly) NSString *fullName;
@property (nonatomic, retain, readonly) NSString *email;
@property (nonatomic, retain, readonly) NSString *phone;
@property (nonatomic, retain, readonly) NSString *firstName;
@property (nonatomic, retain, readonly) NSString *lastName;
@property (nonatomic, retain, readonly) NSString *countryId;
@property (nonatomic, retain, readonly) NSString *city;
@property (nonatomic, retain, readonly) NSString *address;
@property (nonatomic, retain, readonly) NSString *zipcode;
@property (nonatomic, retain, readonly) NSString *stripeToken;

@end

@interface MFMutableCart : MFCart

@property (nonatomic, retain) NSArray *postIds;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *deliveryId;
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger transactionFee;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *countryId;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *zipcode;
@property (nonatomic, retain) NSString *stripeToken;

@end