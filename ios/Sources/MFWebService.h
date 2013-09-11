/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFWebResources, MFWebSession, MFWebUser;
@protocol MFWebServiceDelegate;

@interface MFWebService : NSObject
{
    @private
    __unsafe_unretained id <MFWebServiceDelegate> m_delegate;
    NSOperationQueue *m_queue;
    MFWebSession *m_session;
    NSURL *m_URL;
    MFWebResources *m_resources;
    MFWebUser *m_user;
}

+ (MFWebService *)sharedService;

@property (nonatomic, assign) id <MFWebServiceDelegate> delegate;
@property (nonatomic, retain, readonly) NSURL *URL;
@property (nonatomic, retain, readonly) MFWebResources *resources;
@property (nonatomic, retain, readonly) MFWebUser *user;

- (void)login;
- (void)logout;

@end
