/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebAuthorization.h"
#import "NSDictionary+Additions.h"
#import "NSString+Additions.h"

NSString *MFWebAuthorizationTypeAutomatic = @"auto";
NSString *MFWebAuthorizationTypeEmail = @"email";

#define KEY_TOKEN @"token"
#define KEY_SECRET @"secret"
#define KEY_TYPE @"type"

@implementation MFWebAuthorization

+ (id)authorizationForDeviceID:(NSString *)deviceId
{
    return [[MFWebAuthorization alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           MFWebAuthorizationTypeAutomatic, KEY_TYPE,
                                                           deviceId.sha1Value, KEY_TOKEN,
                                                           ((NSString *)[NSString stringWithFormat:@"%@%@", deviceId, deviceId]).sha1Value, KEY_SECRET, nil]];
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_token = [attributes stringForKey:KEY_TOKEN];
        m_secret = [attributes stringForKey:KEY_SECRET];
        m_type = [attributes stringForKey:KEY_TYPE];
        
        if(!m_token || !m_secret || !m_type) {
            MFError(@"Token, secret and type cannot be nil");
            
            return nil;
        }
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            m_token, KEY_TOKEN,
            m_secret, KEY_SECRET,
            m_type, KEY_TYPE, nil];
}

@synthesize token = m_token;
@synthesize secret = m_secret;
@synthesize type = m_type;

@end
