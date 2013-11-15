/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequestTransform.h"

@class MFUserDetails;

@interface MFWebSession : NSObject <MFWebRequestTransform>
{
    @private
    NSTimeInterval m_timestamp;
    NSString *m_identifier;
    NSString *m_userId;
    MFUserDetails *m_contacts;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;
@property (nonatomic, retain, readonly) MFUserDetails *contacts;
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;
@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, retain, readonly) NSString *userId;

@end
