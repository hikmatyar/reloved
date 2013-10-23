/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequestTransform.h"

typedef enum _MFOrderStatus {
    kMFOrderStatusCancelled = 0,
    kMFOrderStatusPending = 1,
    kMFOrderStatusDeclined = 2,
    kMFOrderStatusAccepted = 3,
    kMFOrderStatusCompleted = 4
} MFOrderStatus;

@interface MFOrder : NSObject <MFWebRequestTransform>
{
    @private
    NSString *m_identifier;
    MFOrderStatus m_status;
    NSDate *m_date;
    NSArray *m_postIds;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, retain, readonly) NSDate *date;
@property (nonatomic, retain, readonly) NSArray *postIds;
@property (nonatomic, assign, readonly) MFOrderStatus status;

@end
