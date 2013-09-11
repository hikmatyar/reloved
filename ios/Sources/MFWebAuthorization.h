/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

extern NSString *MFWebAuthorizationTypeAutomatic;

@interface MFWebAuthorization : NSObject
{
    @private
    NSString *m_token;
    NSString *m_secret;
    NSString *m_type;
}

+ (id)authorizationForDeviceID:(NSString *)deviceId;

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;
@property (nonatomic, retain, readonly) NSString *token;
@property (nonatomic, retain, readonly) NSString *secret;
@property (nonatomic, retain, readonly) NSString *type;

@end
