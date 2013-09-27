/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebAuthorization.h"
#import "MFWebRequest.h"
#import "MFWebResources.h"
#import "MFWebService.h"
#import "MFWebServiceAuthenticationChallenge.h"
#import "MFWebServiceDelegate.h"
#import "MFWebServiceError.h"
#import "MFWebSession.h"
#import "MFWebUser.h"

#define MAX_CONCURRENT 4

#if DEBUG
#define SERVICE_URL @"http://127.0.0.1:3000/"
#else
#define SERVICE_URL @"http://api.relovedapp.co.uk"
#endif

NSString *MFWebServiceErrorDomain = @"MFWebServiceErrorDomain";

@interface MFWebService(Private)

@property (nonatomic, retain, readonly) NSOperationQueue *currentRequests;
@property (nonatomic, retain, readonly) NSMutableSet *pendingRequests;

- (void)logout:(BOOL)notify;

@end

#pragma mark -

@interface MFWebService_AuthenticationChallenge : NSObject <MFWebServiceAuthenticationChallenge>
{
    @private
    __unsafe_unretained MFWebService *m_service;
    NSInteger m_failureCount;
}

- (id)initWithService:(MFWebService *)service;

@end

@implementation MFWebService_AuthenticationChallenge

- (id)initWithService:(MFWebService *)service
{
    self = [super init];
    
    if(self) {
        m_failureCount = 0;
        m_service = service;
    }
    
    return self;
}

#pragma mark MFWebServiceAuthenticationChallenge

- (void)resetFailureCount
{
    m_failureCount = 0;
}

- (void)abortAuthorization
{
    NSError *error = [NSError errorWithDomain:MFWebServiceErrorDomain code:kMFWebServiceErrorInternalAbort userInfo:nil];
    NSSet *requests = [m_service.pendingRequests copy];
    
    [m_service logout:NO];
    
    for(MFWebRequest *request in requests) {
        [request handleError:error];
    }
}

- (void)useAuthorization:(MFWebAuthorization *)authorization
{
    MFWebRequest *request = [[MFWebRequest alloc] initWithService:m_service
                                                             mode:kMFWebRequestModeJsonPost
                                                           target:self
                                                             path:@"/login"
                                                       parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  authorization.type, @"type",
                                                                  authorization.token, @"token",
                                                                  authorization.secret, @"secret", nil]
                                                             sign:NO];
    
    request.block = ^(id target, NSError *error, MFWebSession *session) {
        if(session) {
            m_service.session = session;
        } else {
            m_failureCount += 1;
            
            if([m_service.delegate respondsToSelector:@selector(webService: authenticationChallenge:)]) {
                [m_service.delegate webService:m_service authenticationChallenge:self];
            }
        }
    };
    request.transform = [MFWebSession class];
    
    [m_service.currentRequests addOperation:request];
}

@synthesize failureCount = m_failureCount;

@end

#pragma mark -

@implementation MFWebService

+ (MFWebService *)sharedService
{
    __strong static MFWebService *sharedService = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        sharedService = [[self alloc] init];
    });
    
    return sharedService;
}

- (NSObject *)transformSession:(NSDictionary *)json
{
    return [[MFWebSession alloc] initWithAttributes:json];
}

- (NSOperationQueue *)currentRequests
{
    return m_currentRequests;
}

- (NSMutableSet *)pendingRequests
{
    return m_pendingRequests;
}

@dynamic challenge;

- (id <MFWebServiceAuthenticationChallenge>)challenge
{
    if([m_challenge respondsToSelector:@selector(resetFailureCount)]) {
        [m_challenge resetFailureCount];
    }
    
    return m_challenge;
}

@synthesize delegate = m_delegate;

@synthesize URL = m_URL;
@synthesize resources = m_resources;
@synthesize user = m_user;

@dynamic session;

- (MFWebSession *)session
{
    return m_session;
}

- (void)setSession:(MFWebSession *)session
{
    if(m_session != session) {
        m_session = session;
        
        if(m_session) {
            m_challenge = nil;
            
            for(MFWebRequest *request in m_pendingRequests) {
                [m_currentRequests addOperation:[request cloneWebRequest]];
            }
            
            [m_pendingRequests removeAllObjects];
            
            if([m_delegate respondsToSelector:@selector(webServiceDidLogin:)]) {
                [m_delegate webServiceDidLogin:self];
            }
        }
    }
}

- (void)login
{
    MFDebug(@"login");
    
    if(!m_challenge) {
        m_challenge = [[MFWebService_AuthenticationChallenge alloc] initWithService:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if([m_delegate respondsToSelector:@selector(webService: authenticationChallenge:)]) {
                [m_delegate webService:self authenticationChallenge:m_challenge];
            } else {
                // Wait for the session to be set manually.
            }
        });
    }
}

- (void)logout:(BOOL)notify
{
    [self cancelAllRequests];
    m_session = nil;
    m_challenge = nil;
    
    if(notify) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([m_delegate respondsToSelector:@selector(webServiceDidLogout:)]) {
                [m_delegate webServiceDidLogout:self];
            }
        });
    }
}

- (void)logout
{
    MFDebug(@"logout");
    [self logout:YES];
}

- (void)addRequest:(MFWebRequest *)request
{
    if(m_session || !request.sign) {
        [m_currentRequests addOperation:request];
    } else {
        [m_pendingRequests addObject:request];
        [self login];
    }
}

- (void)resubmitRequest:(MFWebRequest *)request
{
    [m_pendingRequests addObject:request];
    
    if(!m_challenge) {
        m_session = nil;
        [self login];
    }
}

- (void)cancelRequestsForTarget:(id)target
{
    [self cancelRequestsForTarget:target waitUntilFinished:NO];
}

- (void)cancelRequestsForTarget:(id)target waitUntilFinished:(BOOL)flag
{
    NSArray *requests = m_currentRequests.operations;
    NSMutableSet *resubmits = nil;
    
    for(MFWebRequest *request in requests) {
        if(request.target == target) {
            [request cancel];
            
            if(flag) {
                [request waitUntilFinished];
            }
        }
    }
    
    for(MFWebRequest *request in m_pendingRequests) {
        if(request.target == target) {
            if(!resubmits) {
                resubmits = [NSMutableSet set];
            }
            
            [resubmits addObject:request];
        }
    }
    
    for(MFWebRequest *request in resubmits) {
        [m_pendingRequests removeObject:request];
    }
}

- (void)cancelAllRequests
{
    [m_pendingRequests removeAllObjects];
    [m_currentRequests cancelAllOperations];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        m_currentRequests = [[NSOperationQueue alloc] init];
        m_currentRequests.maxConcurrentOperationCount = MAX_CONCURRENT;
        m_pendingRequests = [[NSMutableSet alloc] init];
        m_URL = [[NSURL alloc] initWithString:SERVICE_URL];
        m_resources = [[MFWebResources alloc] initWithService:self];
        m_user = [[MFWebUser alloc] initWithService:self];
    }
    
    return self;
}

@end
