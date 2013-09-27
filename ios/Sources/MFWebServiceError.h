/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

extern NSString *MFWebServiceErrorDomain;

typedef enum _MFWebServiceErrorCode {
    kMFWebServiceErrorNone = 0,
    kMFWebServiceErrorParameterInvalid = 1000,
    kMFWebServiceErrorParameterMissing = 1001,
    kMFWebServiceErrorLimitExceeded = 1018,
    kMFWebServiceErrorAccessDenied = 1019,
    kMFWebServiceErrorSessionRequired = 1020,
    kMFWebServiceErrorSessionExpired = 1021,
    kMFWebServiceErrorSessionInvalid = 1022,
    kMFWebServiceErrorUnknown = 2000,
    kMFWebServiceErrorUnsupportedAPI = 4000,
    kMFWebServiceErrorInternalData = 9000,
    kMFWebServiceErrorInternalAbort = 9001
} MFWebServiceErrorCode;

#define kMFWebServiceErrorAPI_Min kMFWebServiceErrorNone
#define kMFWebServiceErrorAPI_Max kMFWebServiceErrorUnsupportedAPI