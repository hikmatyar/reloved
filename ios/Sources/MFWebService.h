/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFWebCache, MFWebRequest, MFWebSession, MFWebUser;
@protocol MFWebServiceAuthenticationChallenge, MFWebServiceDelegate;

@interface MFWebService : NSObject
{
    @private
    MFWebCache *m_cache;
    id <MFWebServiceAuthenticationChallenge> m_challenge;
    __unsafe_unretained id <MFWebServiceDelegate> m_delegate;
    NSOperationQueue *m_currentRequests;
    NSMutableSet *m_pendingRequests;
    MFWebSession *m_session;
    NSURL *m_URL;
    MFWebUser *m_user;
}

+ (MFWebService *)sharedService;

@property (nonatomic, retain, readonly) MFWebCache *cache;
@property (nonatomic, retain, readonly) id <MFWebServiceAuthenticationChallenge> challenge;
@property (nonatomic, assign) id <MFWebServiceDelegate> delegate;
@property (nonatomic, retain, readonly) NSURL *URL;
@property (nonatomic, retain) MFWebSession *session;
@property (nonatomic, retain, readonly) MFWebUser *user;

- (void)login;
- (void)logout;

- (void)addRequest:(MFWebRequest *)request;
- (void)cancelRequestsForTarget:(id)target;
- (void)cancelRequestsForTarget:(id)target waitUntilFinished:(BOOL)flag;
- (void)cancelAllRequests;

@end
