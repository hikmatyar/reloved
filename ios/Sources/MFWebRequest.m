/* Copyright (c) 2013 Meep Factory OU */

#import "JSONKit.h"
#import "MFWebRequest.h"
#import "MFWebRequestTransform.h"
#import "MFWebService.h"
#import "MFWebServiceError.h"
#import "MFWebSession.h"

#define KEY_TIMESTAMP @"_t"
#define KEY_USERID @"_u"
#define KEY_SESSIONID @"_s"
#define KEY_VERSION @"_v"

@interface MFWebService(Requests)

- (void)resubmitRequest:(MFWebRequest *)request;

@end

#pragma mark -

@implementation MFWebRequest

- (id)initWithService:(MFWebService *)service mode:(MFWebRequestMode)mode target:(id)target URL:(NSURL *)URL parameters:(NSDictionary *)parameters sign:(BOOL)sign
{
    self = [super initWithURL:URL];
    
    if(self) {
        Class klass = [NSNull class];
        
        m_mode = mode;
        m_target = target;
        m_service = service;
        m_sign = sign;
        
        // Workaround to iOS 6.0 POST caching bug
        [self setPostValue:[NSString stringWithFormat:@"%g", [NSDate timeIntervalSinceReferenceDate]] forKey:KEY_TIMESTAMP];
        
        if(sign) {
            MFWebSession *session = service.session;
            
            [self setPostValue:(session) ? session.userId : @"" forKey:KEY_USERID];
            [self setPostValue:(session) ? session.identifier : @"" forKey:KEY_SESSIONID];
        }
        
        for(NSString *key in parameters.keyEnumerator) {
            NSObject *parameter = [parameters objectForKey:key];
            
            if(![parameter isMemberOfClass:klass]) {
                [self setPostValue:parameter forKey:key];
            }
        }
        
        switch(m_mode) {
            case kMFWebRequestModeGet:
            case kMFWebRequestModeJsonGet:
            default:
                self.requestMethod = @"GET";
                break;
            case kMFWebRequestModeJsonPost:
                self.requestMethod = @"POST";
                break;
        }
    }
    
    return self;
}

- (id)initWithService:(MFWebService *)service mode:(MFWebRequestMode)mode target:(id)target path:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [self initWithService:service mode:mode target:target path:path parameters:parameters sign:YES];
}

- (id)initWithService:(MFWebService *)service mode:(MFWebRequestMode)mode target:(id)target path:(NSString *)path parameters:(NSDictionary *)parameters sign:(BOOL)sign
{
    return [self initWithService:service mode:mode target:target URL:[[NSURL alloc] initWithString:path relativeToURL:service.URL] parameters:parameters sign:sign];
}

@synthesize block = m_block;
@synthesize mode = m_mode;
@synthesize sign = m_sign;
@synthesize target = m_target;
@synthesize transform = m_transform;

- (void)handleData:(NSDictionary *)json
{
    if(!self.isCancelled) {
        NSObject *result = (m_transform) ? [m_transform parseFromObject:json] : json;
        
        if([result isKindOfClass:[NSError class]] || [result isMemberOfClass:[NSError class]]) {
            m_block(m_target, (NSError *)result, nil);
        } else if(result != nil) {
            m_block(m_target, nil, result);
        } else {
            m_block(m_target, [NSError errorWithDomain:MFWebServiceErrorDomain code:kMFWebServiceErrorInternalData userInfo:nil], nil);
        }
    }
}

- (void)handleError:(NSError *)_error
{
    if(!self.isCancelled) {
        if([_error.domain isEqualToString:MFWebServiceErrorDomain]) {
            switch(_error.code) {
                case kMFWebServiceErrorSessionExpired:
                case kMFWebServiceErrorSessionInvalid:
                    [m_service resubmitRequest:self];
                    return;
                default:
                    break;
            }
        }
        
        m_block(m_target, _error, nil);
    }
}

- (void)handleRaw:(NSError *)error
{
    if(!self.isCancelled) {
        m_block(m_target, nil, nil);
    }
}

- (void)handleResponse
{
    if(m_mode == kMFWebRequestModeJsonGet || m_mode == kMFWebRequestModeJsonPost) {
        NSData *data = self.responseData;
        NSDictionary *json = [data objectFromJSONData];
        
        if([json isKindOfClass:[NSDictionary class]]) {
            NSNumber *_error = [json objectForKey:@"error"];
            
            if(_error && ![_error isMemberOfClass:[NSNumber class]] && ![_error isKindOfClass:[NSNumber class]]) {
                MFLog(@"%@: Received error response\n\n%@", self.class, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                [self performSelectorOnMainThread:@selector(handleError:) withObject:[NSError errorWithDomain:MFWebServiceErrorDomain code:kMFWebServiceErrorInternalData userInfo:nil] waitUntilDone:[NSThread isMainThread]];
            } else if(_error && _error.integerValue != 0) {
                NSInteger code = _error.integerValue;
                
                if(code < kMFWebServiceErrorAPI_Min || code > kMFWebServiceErrorAPI_Max) {
                    MFLog(@"%@: Received unknown API error (%d)\n", self.class, code);
                    code = kMFWebServiceErrorUnknown;
                }
                
                [self performSelectorOnMainThread:@selector(handleError:) withObject:[NSError errorWithDomain:MFWebServiceErrorDomain code:code userInfo:nil] waitUntilDone:[NSThread isMainThread]];
            } else {
                [self performSelectorOnMainThread:@selector(handleData:) withObject:json waitUntilDone:[NSThread isMainThread]];
            }
        } else {
            NSLog(@"%@", [[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding]);
            MFLog(@"%@: Received invalid response\n\n%@", self.class, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            [self performSelectorOnMainThread:@selector(handleError:) withObject:[NSError errorWithDomain:MFWebServiceErrorDomain code:kMFWebServiceErrorInternalData userInfo:nil] waitUntilDone:[NSThread isMainThread]];
        }
    } else {
        [self performSelectorOnMainThread:@selector(handleRaw:) withObject:nil waitUntilDone:[NSThread isMainThread]];
    }
}

- (id)cloneWebRequest
{
    MFWebRequest *webRequest = [[self.class alloc] initWithURL:self.url];
    
    if(webRequest) {
        for(NSDictionary *pair in postData) {
            NSString *key = [pair objectForKey:@"key"];
            NSString *value = [pair objectForKey:@"value"];
            
            if([key isEqualToString:KEY_TIMESTAMP]) {
                [webRequest setPostValue:[NSString stringWithFormat:@"%g", [NSDate timeIntervalSinceReferenceDate]] forKey:KEY_TIMESTAMP];
            } else if([key isEqualToString:KEY_USERID]) {
                MFWebSession *session = m_service.session;
                
                [webRequest setPostValue:(session) ? session.userId : @"" forKey:KEY_USERID];
            } else if([key isEqualToString:KEY_SESSIONID]) {
                MFWebSession *session = m_service.session;
                
                [webRequest setPostValue:(session) ? session.identifier : @"" forKey:KEY_SESSIONID];
            } else {
                [webRequest setPostValue:value forKey:key];
            }
        }
        
        webRequest->m_target = m_target;
        webRequest->m_service = m_service;
        webRequest->m_sign = m_sign;
        webRequest->m_mode = m_mode;
        webRequest->m_transform = m_transform;
        webRequest.block = m_block;
    }
    
    return webRequest;
}

#pragma mark HTTPASIRequest

- (void)setPostValue:(id <NSObject>)value forKey:(NSString *)key
{
    if(m_mode == kMFWebRequestModeGet || m_mode == kMFWebRequestModeJsonGet) {
        if(value && key) {
            NSString *str = self.url.absoluteString;
            NSString *value_ = @"";
            NSURL *url_;
            
            if([value isKindOfClass:[NSString class]]) {
                value_ = (NSString *)value;
            } else if([value isKindOfClass:[NSNumber class]]) {
                value_ = ((NSNumber *)value).stringValue;
            }
            
            str = [str stringByAppendingFormat:@"%@%@=%@", (([str rangeOfString:@"?"].location == NSNotFound) ? @"?" : @"&"), [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [value_ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            url_ = [NSURL URLWithString:str];
            
            if(url_) {
                self.url = url_;
            }
        }
    } else {
        [super setPostValue:value forKey:key];
    }
}

- (void)requestFinished
{
    if(!self.error) {
        [self handleResponse];
    }
    
    [super requestFinished];
}

- (void)reportFailure
{
    [self handleError:self.error];
}

- (void)cancel
{
    m_target = nil;
    m_service = nil;
    [super cancel];
}

@end
