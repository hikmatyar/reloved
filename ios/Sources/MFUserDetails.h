/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequestTransform.h"

@interface MFUserDetails : NSObject <MFWebRequestTransform>
{
    @protected
    NSString *m_sizeId;
    NSString *m_mediaId;
    NSString *m_email;
    NSString *m_phone;
    NSString *m_firstName;
    NSString *m_lastName;
    NSString *m_countryId;
    NSString *m_city;
    NSString *m_address;
    NSString *m_zipcode;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, retain, readonly) NSString *sizeId;
@property (nonatomic, retain, readonly) NSString *mediaId;
@property (nonatomic, retain, readonly) NSString *email;
@property (nonatomic, retain, readonly) NSString *phone;
@property (nonatomic, retain, readonly) NSString *firstName;
@property (nonatomic, retain, readonly) NSString *lastName;
@property (nonatomic, retain, readonly) NSString *countryId;
@property (nonatomic, retain, readonly) NSString *city;
@property (nonatomic, retain, readonly) NSString *address;
@property (nonatomic, retain, readonly) NSString *zipcode;

@end

@interface MFMutableUserDetails : MFUserDetails

@property (nonatomic, retain) NSString *sizeId;
@property (nonatomic, retain) NSString *mediaId;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *countryId;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *zipcode;

@end