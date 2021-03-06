/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequestTransform.h"

typedef enum _MFPostChange {
    kMFPostChangeNone = 0x00,
    kMFPostChangeStatus = (1 << 0),
    kMFPostChangeAll = 0xFF
} MFPostChange;

typedef enum _MFPostStatus {
    kMFPostStatusDeleted = 0,
    kMFPostStatusUnlisted = 1,
    kMFPostStatusListed = 2,
    kMFPostStatusListedPendingPurchase = 3,
    kMFPostStatusListedBought = 4,
    kMFPostStatusUnlistedBought = 5
} MFPostStatus;

@interface MFPost : NSObject <NSCopying, NSMutableCopying, MFWebRequestTransform>
{
    @protected
    NSDate *m_date;
    NSDate *m_modified;
    NSString *m_identifier;
    MFPostStatus m_status;
    NSString *m_title;
    NSString *m_userId;
    NSString *m_sizeId;
    NSString *m_brandId;
    NSString *m_conditionId;
    NSArray *m_typeIds;
    NSArray *m_colorIds;
    NSArray *m_mediaIds;
    NSInteger m_price;
    NSInteger m_priceOriginal;
    NSString *m_currency;
    NSString *m_materials;
    NSString *m_editorial;
    NSString *m_fit;
    NSString *m_notes;
    NSArray *m_tags;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;
- (NSDictionary *)attributesForChanges:(MFPostChange)changes;

@property (nonatomic, retain, readonly) NSString *csum;
@property (nonatomic, assign, readonly, getter = isActive) BOOL active;
@property (nonatomic, retain, readonly) NSDate *date;
@property (nonatomic, retain, readonly) NSDate *modified;
@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, assign, readonly) MFPostStatus status;
@property (nonatomic, retain, readonly) NSString *title;
@property (nonatomic, retain, readonly) NSString *userId;
@property (nonatomic, retain, readonly) NSString *sizeId;
@property (nonatomic, retain, readonly) NSString *brandId;
@property (nonatomic, retain, readonly) NSString *conditionId;
@property (nonatomic, retain, readonly) NSArray *typeIds;
@property (nonatomic, retain, readonly) NSArray *colorIds;
@property (nonatomic, retain, readonly) NSArray *mediaIds;
@property (nonatomic, assign, readonly) NSInteger price;
@property (nonatomic, assign, readonly) NSInteger priceOriginal;
@property (nonatomic, retain, readonly) NSString *currency;
@property (nonatomic, retain, readonly) NSString *materials;
@property (nonatomic, retain, readonly) NSString *editorial;
@property (nonatomic, retain, readonly) NSString *fit;
@property (nonatomic, retain, readonly) NSString *notes;
@property (nonatomic, retain, readonly) NSArray *tags;

@end

@interface MFMutablePost : MFPost
{
    @protected
    NSArray *m_imagePaths;
    NSString *m_email;
    NSString *m_phone;
    NSString *m_firstName;
    NSString *m_lastName;
}

@property (nonatomic, retain) NSArray *imagePaths;
@property (nonatomic, assign) MFPostStatus status;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *sizeId;
@property (nonatomic, retain) NSString *brandId;
@property (nonatomic, retain) NSString *conditionId;
@property (nonatomic, retain) NSArray *typeIds;
@property (nonatomic, retain) NSArray *colorIds;
@property (nonatomic, retain) NSArray *mediaIds;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger priceOriginal;
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, retain) NSString *materials;
@property (nonatomic, retain) NSString *editorial;
@property (nonatomic, retain) NSString *fit;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSArray *tags;

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain, readonly) NSString *fullName;

- (BOOL)update:(NSDictionary *)changes;
- (BOOL)updateStatus:(MFPostStatus)status;

@end
