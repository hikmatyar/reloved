/* Copyright (c) 2013 Meep Factory OU */

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

@synthesize delegate = m_delegate;

@synthesize URL = m_URL;
@synthesize resources = m_resources;
@synthesize user = m_user;

- (void)login
{
    
}

- (void)logout
{
    
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        m_queue = [[NSOperationQueue alloc] init];
        m_queue.maxConcurrentOperationCount = MAX_CONCURRENT;
        m_URL = [[NSURL alloc] initWithString:SERVICE_URL];
        m_resources = [[MFWebResources alloc] initWithService:self];
        m_user = [[MFWebUser alloc] initWithService:self];
    }
    
    return self;
}

@end
