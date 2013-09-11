/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFWebService;

@interface MFWebResources : NSObject
{
    @private
    __unsafe_unretained MFWebService *m_service;
}

- (id)initWithService:(MFWebService *)service;

@property (nonatomic, assign, readonly) MFWebService *service;

@end
