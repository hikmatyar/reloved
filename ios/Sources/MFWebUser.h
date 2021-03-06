/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFWebService;

@interface MFWebUser : NSObject
{
    @private
    __unsafe_unretained MFWebService *m_service;
}

- (id)initWithService:(MFWebService *)service;

@property (nonatomic, assign, readonly) MFWebService *service;

@end
