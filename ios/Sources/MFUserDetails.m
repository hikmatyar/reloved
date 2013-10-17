/* Copyright (c) 2013 Meep Factory OU */

#import "MFUserDetails.h"
#import "NSDictionary+Additions.h"

#define KEY_MEDIA @"media"
#define KEY_EMAIL @"email"
#define KEY_PHONE @"phone"
#define KEY_FIRST_NAME @"first_name"
#define KEY_LAST_NAME @"last_name"
#define KEY_COUNTRY @"country"
#define KEY_CITY @"city"
#define KEY_ADDRESS @"address"
#define KEY_ZIPCODE @"zipcode"

@implementation MFUserDetails

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_mediaId = [attributes identifierForKey:KEY_MEDIA];
        m_email = [attributes stringForKey:KEY_EMAIL];
        m_phone = [attributes stringForKey:KEY_PHONE];
        m_firstName = [attributes stringForKey:KEY_FIRST_NAME];
        m_lastName = [attributes stringForKey:KEY_LAST_NAME];
        m_countryId = [attributes identifierForKey:KEY_COUNTRY];
        m_city = [attributes stringForKey:KEY_CITY];
        m_address = [attributes stringForKey:KEY_ADDRESS];
        m_zipcode = [attributes stringForKey:KEY_ZIPCODE];
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setValue:m_mediaId forKey:KEY_MEDIA];
    [attributes setValue:m_email forKey:KEY_EMAIL];
    [attributes setValue:m_phone forKey:KEY_PHONE];
    [attributes setValue:m_firstName forKey:KEY_FIRST_NAME];
    [attributes setValue:m_lastName forKey:KEY_LAST_NAME];
    [attributes setValue:m_countryId forKey:KEY_COUNTRY];
    [attributes setValue:m_city forKey:KEY_CITY];
    [attributes setValue:m_address forKey:KEY_ADDRESS];
    [attributes setValue:m_zipcode forKey:KEY_ZIPCODE];
    
    return attributes;
}

@synthesize sizeId = m_sizeId;
@synthesize mediaId = m_mediaId;
@synthesize email = m_email;
@synthesize phone = m_phone;
@synthesize firstName = m_firstName;
@synthesize lastName = m_lastName;
@synthesize countryId = m_countryId;
@synthesize city = m_city;
@synthesize address = m_address;
@synthesize zipcode = m_zipcode;

#pragma mark MFWebRequestTransform

+ (id)parseFromObject:(id)object
{
    return ([object isKindOfClass:[NSDictionary class]]) ? [[self alloc] initWithAttributes:(NSDictionary *)object] : nil;
}

@end

#pragma mark -

@implementation MFMutableUserDetails

- (void)setSizeId:(NSString *)sizeId
{
    m_sizeId = sizeId;
}

- (void)setMediaId:(NSString *)mediaId
{
    m_mediaId = mediaId;
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

@end