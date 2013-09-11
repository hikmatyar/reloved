/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFWebService;
@protocol MFWebServiceAuthenticationChallenge;

@protocol MFWebServiceDelegate <NSObject>

@optional

- (void)webService:(MFWebService *)webService authenticationChallenge:(id <MFWebServiceAuthenticationChallenge>)challenge;

- (void)webServiceDidLogin:(MFWebService *)webService;
- (void)webServiceDidLogout:(MFWebService *)webService;

@end
