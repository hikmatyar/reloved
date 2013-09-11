/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

extern NSString *MFWebServiceErrorDomain;

typedef enum _MFWebServiceErrorCode {
    kMFWebServiceErrorNone = 0,
    kMFWebServiceErrorUnknown = 2000,
    kMFWebServiceErrorUnsupportedAPI = 2001,
    kMFWebServiceErrorInternalData = 9000,
    kMFWebServiceErrorInternalAbort = 9001
} MFWebServiceErrorCode;

#define kMFWebServiceErrorAPI_Min kMFWebServiceErrorNone
#define kMFWebServiceErrorAPI_Max kMFWebServiceErrorUnsupportedAPI