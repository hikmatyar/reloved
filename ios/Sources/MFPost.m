/* Copyright (c) 2013 Meep Factory OU */

#import "MFPost.h"
#import "NSDate+Additions.h"
#import "NSDictionary+Additions.h"
#import "NSString+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_USER @"user"
#define KEY_STATUS @"status"
#define KEY_DATE @"date"
#define KEY_MODIFIED @"mod"
#define KEY_BRAND @"brand"
#define KEY_COLOR @"color"
#define KEY_MEDIA @"media"
#define KEY_CONDITION @"condition"
#define KEY_TYPES @"types"
#define KEY_SIZE @"size"
#define KEY_MATERIALS @"materials"
#define KEY_PRICE @"price"
#define KEY_PRICE_ORIGINAL @"price_o"
#define KEY_CURRENCY @"currency"
#define KEY_TITLE @"title"
#define KEY_FIT @"fit"
#define KEY_NOTES @"notes"
#define KEY_EDITORIAL @"editorial"
#define KEY_TAGS @"tags"

@implementation MFPost

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_identifier = [attributes identifierForKey:KEY_IDENTIFIER];
        m_userId = [attributes identifierForKey:KEY_USER];
        m_status = (MFPostStatus)[attributes integerForKey:KEY_STATUS];
        m_date = [attributes stringForKey:KEY_DATE].datetimeValue;
        m_modified = [attributes stringForKey:KEY_MODIFIED].datetimeValue;
        m_brandId = [attributes identifierForKey:KEY_BRAND];
        m_colorIds = [attributes arrayOfIdentifiersForKey:KEY_COLOR];
        m_mediaIds = [attributes arrayOfIdentifiersForKey:KEY_MEDIA];
        m_conditionId = [attributes identifierForKey:KEY_CONDITION];
        m_typeIds = [attributes arrayOfIdentifiersForKey:KEY_TYPES];
        m_sizeId = [attributes identifierForKey:KEY_SIZE];
        m_materials = [attributes stringForKey:KEY_MATERIALS];
        m_price = [attributes integerForKey:KEY_PRICE];
        m_priceOriginal = [attributes integerForKey:KEY_PRICE_ORIGINAL];
        m_currency = [attributes stringForKey:KEY_CURRENCY];
        m_title = [attributes stringForKey:KEY_TITLE];
        m_fit = [attributes stringForKey:KEY_FIT];
        m_notes = [attributes stringForKey:KEY_NOTES];
        m_editorial = [attributes stringForKey:KEY_EDITORIAL];
        m_tags = [attributes arrayForKey:KEY_TAGS];
        
        if(!m_identifier && !m_title && !m_date) {
            return nil;
        }
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    return [self attributesForChanges:kMFPostChangeAll];
}

- (NSDictionary *)attributesForChanges:(MFPostChange)changes
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setValue:m_identifier forKey:KEY_IDENTIFIER];
    
    if((changes & kMFPostChangeStatus) == kMFPostChangeStatus) {
        [attributes setValue:[NSNumber numberWithInteger:m_status] forKey:KEY_STATUS];
    }
    
    if((changes & kMFPostChangeAll) == kMFPostChangeAll) {
        [attributes setValue:m_userId forKey:KEY_USER];
        [attributes setValue:m_date.datetimeString forKey:KEY_DATE];
        [attributes setValue:m_modified.datetimeString forKey:KEY_MODIFIED];
        [attributes setValue:m_brandId forKey:KEY_BRAND];
        [attributes setValue:m_colorIds forKey:KEY_COLOR];
        [attributes setValue:m_mediaIds forKey:KEY_MEDIA];
        [attributes setValue:m_conditionId forKey:KEY_CONDITION];
        [attributes setValue:m_typeIds forKey:KEY_TYPES];
        [attributes setValue:m_sizeId forKey:KEY_SIZE];
        [attributes setValue:m_materials forKey:KEY_MATERIALS];
        [attributes setValue:[NSNumber numberWithInteger:m_price] forKey:KEY_PRICE];
        [attributes setValue:[NSNumber numberWithInteger:m_priceOriginal] forKey:KEY_PRICE_ORIGINAL];
        [attributes setValue:m_currency forKey:KEY_CURRENCY];
        [attributes setValue:m_title forKey:KEY_TITLE];
        [attributes setValue:m_fit forKey:KEY_FIT];
        [attributes setValue:m_notes forKey:KEY_NOTES];
        [attributes setValue:m_editorial forKey:KEY_EDITORIAL];
        [attributes setValue:m_tags forKey:KEY_TAGS];
    }
    
    return attributes;
}

@dynamic active;

- (BOOL)isActive
{
    return (m_status == kMFPostStatusListed) ? YES : NO;
}

@synthesize date = m_date;
@synthesize modified = m_modified;
@synthesize identifier = m_identifier;
@synthesize status = m_status;
@synthesize title = m_title;
@synthesize userId = m_userId;
@synthesize sizeId = m_sizeId;
@synthesize brandId = m_brandId;
@synthesize conditionId = m_conditionId;
@synthesize typeIds = m_typeIds;
@synthesize colorIds = m_colorIds;
@synthesize mediaIds = m_mediaIds;
@synthesize price = m_price;
@synthesize priceOriginal = m_priceOriginal;
@synthesize currency = m_currency;
@synthesize materials = m_materials;
@synthesize editorial = m_editorial;
@synthesize fit = m_fit;
@synthesize notes = m_notes;
@synthesize tags = m_tags;

- (BOOL)update:(NSDictionary *)changes
{
    BOOL changed = NO;
    NSString *str;
    NSNumber *num;
    NSArray *arr;
    
    if((str = [changes identifierForKey:KEY_IDENTIFIER]) != nil && !MFEqual(m_identifier, str)) {
        m_identifier = str;
        changed = YES;
    }
    
    if((str = [changes identifierForKey:KEY_USER]) != nil && !MFEqual(m_userId, str)) {
        m_userId = str;
        changed = YES;
    }
    
    if((num = [changes numberForKey:KEY_STATUS]) != nil && num.integerValue != m_status) {
        m_status = num.integerValue;
        changed = YES;
    }
    
    if((str = [changes identifierForKey:KEY_DATE]) != nil && !MFEqual(m_date.datetimeString, str)) {
        m_date = str.datetimeValue;
        changed = YES;
    }
    
    if((str = [changes identifierForKey:KEY_MODIFIED]) != nil && !MFEqual(m_modified.datetimeString, str)) {
        m_modified = str.datetimeValue;
        changed = YES;
    }
    
    if((str = [changes identifierForKey:KEY_BRAND]) != nil && !MFEqual(m_brandId, str)) {
        m_brandId = str;
        changed = YES;
    }
    
    if((arr = [changes arrayOfIdentifiersForKey:KEY_COLOR]) != nil && !MFEqual(m_colorIds, arr)) {
        m_colorIds = arr;
        changed = YES;
    }
    
    if((arr = [changes arrayOfIdentifiersForKey:KEY_MEDIA]) != nil && !MFEqual(m_mediaIds, arr)) {
        m_mediaIds = arr;
        changed = YES;
    }
    
    if((str = [changes identifierForKey:KEY_CONDITION]) != nil && !MFEqual(m_conditionId, str)) {
        m_conditionId = str;
        changed = YES;
    }
    
    if((arr = [changes arrayOfIdentifiersForKey:KEY_TYPES]) != nil && !MFEqual(m_typeIds, arr)) {
        m_typeIds = arr;
        changed = YES;
    }
    
    if((str = [changes identifierForKey:KEY_SIZE]) != nil && !MFEqual(m_sizeId, str)) {
        m_sizeId = str;
        changed = YES;
    }
    
    if((str = [changes identifierForKey:KEY_MATERIALS]) != nil && !MFEqual(m_materials, str)) {
        m_materials = str;
        changed = YES;
    }
    
    if((num = [changes numberForKey:KEY_PRICE]) != nil && num.integerValue != m_price) {
        m_price = num.integerValue;
        changed = YES;
    }
    
    if((num = [changes numberForKey:KEY_PRICE_ORIGINAL]) != nil && num.integerValue != m_priceOriginal) {
        m_priceOriginal = num.integerValue;
        changed = YES;
    }
    
    if((str = [changes identifierForKey:KEY_CURRENCY]) != nil && !MFEqual(m_currency, str)) {
        m_currency = str;
        changed = YES;
    }
    
    if((str = [changes identifierForKey:KEY_TITLE]) != nil && !MFEqual(m_title, str)) {
        m_title = str;
        changed = YES;
    }
    
    if((str = [changes identifierForKey:KEY_FIT]) != nil && !MFEqual(m_fit, str)) {
        m_fit = str;
        changed = YES;
    }
    
    if((str = [changes identifierForKey:KEY_NOTES]) != nil && !MFEqual(m_notes, str)) {
        m_notes = str;
        changed = YES;
    }
    
    if((str = [changes identifierForKey:KEY_EDITORIAL]) != nil && !MFEqual(m_editorial, str)) {
        m_editorial = str;
        changed = YES;
    }
    
    if((arr = [changes arrayForKey:KEY_TAGS]) != nil && !MFEqual(m_tags, arr)) {
        m_tags = arr;
        changed = YES;
    }
    
    return changed;
}

#pragma mark MFWebRequestTransform

+ (id)parseFromObject:(id)object
{
    return ([object isKindOfClass:[NSDictionary class]]) ? [[self alloc] initWithAttributes:(NSDictionary *)object] : nil;
}

#pragma mark NSObject

- (BOOL)isEqual:(MFPost *)post
{
    return [post.identifier isEqualToString:m_identifier];
}

@end

#pragma mark -

@implementation MFMutablePost

@synthesize imagePaths = m_imagePaths;

@dynamic title;

- (void)setTitle:(NSString *)title
{
    m_title = title;
}

@dynamic sizeId;

- (void)setSizeId:(NSString *)sizeId
{
    m_sizeId = sizeId;
}

@dynamic status;

- (void)setStatus:(MFPostStatus)status
{
    m_status = status;
}

@dynamic identifier;

- (void)setIdentifier:(NSString *)identifier
{
    m_identifier = identifier;
}

@dynamic brandId;

- (void)setBrandId:(NSString *)brandId
{
    m_brandId = brandId;
}

@dynamic conditionId;

- (void)setConditionId:(NSString *)conditionId
{
    m_conditionId = conditionId;
}

@dynamic typeIds;

- (void)setTypeIds:(NSArray *)typeIds
{
    m_typeIds = typeIds;
}

@dynamic colorIds;

- (void)setColorIds:(NSArray *)colorIds
{
    m_colorIds = colorIds;
}

@dynamic mediaIds;

- (void)setMediaIds:(NSArray *)mediaIds
{
    m_mediaIds = mediaIds;
}

@dynamic price;

- (void)setPrice:(NSInteger)price
{
    m_price = price;
}

@dynamic priceOriginal;

- (void)setPriceOriginal:(NSInteger)priceOriginal
{
    m_priceOriginal = priceOriginal;
}

@dynamic currency;

- (void)setCurrency:(NSString *)currency
{
    m_currency = currency;
}

@dynamic materials;

- (void)setMaterials:(NSString *)materials
{
    m_materials = materials;
}

@dynamic editorial;

- (void)setEditorial:(NSString *)editorial
{
    m_editorial = editorial;
}

@dynamic fit;

- (void)setFit:(NSString *)fit
{
    m_fit = fit;
}

@dynamic notes;

- (void)setNotes:(NSString *)notes
{
    m_notes = notes;
}

@dynamic tags;

- (void)setTags:(NSArray *)tags
{
    m_tags = tags;
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        m_status = kMFPostStatusUnlisted;
    }
    
    return self;
}

@end