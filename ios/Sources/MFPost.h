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
    NSDate *m_date;
    NSDate *m_modified;
    NSString *m_identifier;
    MFPostStatus m_status;
    NSString *m_title;
    NSString *m_userId;
    NSString *m_sizeId;
    NSString *m_brandId;
    NSString *m_conditionId;
    NSString *m_typeId;
    NSArray *m_colorIds;
    NSArray *m_mediaIds;
    NSInteger m_price;
    NSInteger m_priceOriginal;
    NSString *m_currency;
    NSString *m_materials;
    NSString *m_editorial;
    NSString *m_fit;
    NSString *m_notes;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

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
@property (nonatomic, retain, readonly) NSString *typeId;
@property (nonatomic, retain, readonly) NSArray *colorIds;
@property (nonatomic, retain, readonly) NSArray *mediaIds;
@property (nonatomic, assign, readonly) NSInteger price;
@property (nonatomic, assign, readonly) NSInteger priceOriginal;
@property (nonatomic, retain, readonly) NSString *currency;
@property (nonatomic, retain, readonly) NSString *materials;
@property (nonatomic, retain, readonly) NSString *editorial;
@property (nonatomic, retain, readonly) NSString *fit;
@property (nonatomic, retain, readonly) NSString *notes;

- (BOOL)update:(NSDictionary *)changes;

@end

@interface MFMutablePost : MFPost
{
    @protected
    NSArray *m_imagePaths;
}

@property (nonatomic, retain) NSArray *imagePaths;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *sizeId;
@property (nonatomic, retain) NSString *brandId;
@property (nonatomic, retain) NSString *conditionId;
@property (nonatomic, retain) NSString *typeId;
@property (nonatomic, retain) NSArray *colorIds;
@property (nonatomic, retain) NSArray *mediaIds;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger priceOriginal;
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, retain) NSString *materials;
@property (nonatomic, retain) NSString *editorial;
@property (nonatomic, retain) NSString *fit;
@property (nonatomic, retain) NSString *notes;

@end
