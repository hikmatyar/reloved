/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

typedef enum _MFPostStatus {
    kMFPostStatusDeleted = 0,
    kMFPostStatusUnlisted = 1,
    kMFPostStatusListed = 2,
    kMFPostStatusListedPendingPurchase = 3,
    kMFPostStatusListedBought = 4,
    kMFPostStatusUnlistedBought = 5
} MFPostStatus;

@interface MFPost : NSObject
{
    @protected
    NSDate *m_created;
    NSString *m_identifier;
    MFPostStatus m_status;
    NSString *m_title;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, assign, readonly, getter = isActive) BOOL active;
@property (nonatomic, retain, readonly) NSDate *created;
@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, assign, readonly) MFPostStatus status;
@property (nonatomic, retain, readonly) NSString *title;

- (BOOL)update:(NSDictionary *)changes;

@end

@interface MFMutablePost : MFPost
{
    @private
    NSArray *m_imagePaths;
}

@property (nonatomic, retain) NSArray *imagePaths;

@end
