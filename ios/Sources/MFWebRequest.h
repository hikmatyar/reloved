/* Copyright (c) 2013 Meep Factory OU */

#import "ASIFormDataRequest.h"

@class MFWebService;

typedef enum _MFWebRequestMode {
    kMFWebRequestModeGet = 0,
    kMFWebRequestModeJsonGet,
    kMFWebRequestModeJsonPost
} MFWebRequestMode;

typedef void (^MFWebRequestBlock)(id target, NSError *error, id result);

@interface MFWebRequest : ASIFormDataRequest
{
    @protected
    MFWebRequestBlock m_block;
    MFWebRequestMode m_mode;
    __unsafe_unretained id m_target;
    Class m_transform;
    __unsafe_unretained MFWebService *m_service;
    BOOL m_sign;
}

- (id)initWithService:(MFWebService *)service mode:(MFWebRequestMode)mode target:(id)target path:(NSString *)path parameters:(NSDictionary *)parameters;
- (id)initWithService:(MFWebService *)service mode:(MFWebRequestMode)mode target:(id)target path:(NSString *)path parameters:(NSDictionary *)parameters sign:(BOOL)sign;
- (id)initWithService:(MFWebService *)service mode:(MFWebRequestMode)mode target:(id)target URL:(NSURL *)URL parameters:(NSDictionary *)parameters sign:(BOOL)sign;

@property (nonatomic, copy) MFWebRequestBlock block;
@property (nonatomic, assign, readonly) MFWebRequestMode mode;
@property (nonatomic, assign, readonly) BOOL sign;
@property (nonatomic, assign, readonly) id target;
@property (nonatomic, assign) Class transform;

- (void)handleData:(NSDictionary *)json;
- (void)handleError:(NSError *)error;
- (id)cloneWebRequest;

@end