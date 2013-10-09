/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrand.h"
#import "MFColor.h"
#import "MFCountry.h"
#import "MFCurrency.h"
#import "MFDelivery.h"
#import "MFFeed.h"
#import "MFPost.h"
#import "MFSize.h"
#import "MFType.h"
#import "NSDictionary+Additions.h"

#define KEY_BRANDS @"brands"
#define KEY_CHANGES @"changes"
#define KEY_COLORS @"colors"
#define KEY_COUNTRIES @"countries"
#define KEY_CURSOR @"cursor"
#define KEY_CURRENCIES @"currencies"
#define KEY_DELIVERIES @"deliveries"
#define KEY_PREFIX @"prefix"
#define KEY_POSTS @"posts"
#define KEY_SIZES @"sizes"
#define KEY_STATE @"state"
#define KEY_GLOBALS @"globals"
#define KEY_TYPES @"types"
#define KEY_OFFSET @"offset"

@implementation MFFeed

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        Class klass = [NSDictionary class];
        NSString *cursor = [attributes stringForKey:KEY_CURSOR];
        NSString *prefix = [attributes stringForKey:KEY_PREFIX];
        NSMutableArray *currencies = nil;
        NSMutableArray *posts = nil;
        NSMutableArray *brands = nil;
        NSMutableArray *colors = nil;
        NSMutableArray *countries = nil;
        NSMutableArray *deliveries = nil;
        NSMutableArray *types = nil;
        NSMutableArray *sizes = nil;
        
        for(NSDictionary *json in [attributes arrayForKey:KEY_CURRENCIES]) {
            if([json isKindOfClass:klass]) {
                MFCurrency *currency = [[MFCurrency alloc] initWithAttributes:json];
                
                if(currency) {
                    if(!currencies) {
                        currencies = [NSMutableArray array];
                    }
                    
                    [currencies addObject:currency];
                }
            }
        }
        
        for(NSDictionary *json in [attributes arrayForKey:KEY_POSTS]) {
            if([json isKindOfClass:klass]) {
                MFPost *post = [[MFPost alloc] initWithAttributes:json];
                
                if(post) {
                    if(!posts) {
                        posts = [NSMutableArray array];
                    }
                    
                    [posts addObject:post];
                }
            }
        }
        
        for(NSDictionary *json in [attributes arrayForKey:KEY_BRANDS]) {
            if([json isKindOfClass:klass]) {
                MFBrand *brand = [[MFBrand alloc] initWithAttributes:json];
                
                if(brand) {
                    if(!brands) {
                        brands = [NSMutableArray array];
                    }
                    
                    [brands addObject:brand];
                }
            }
        }
        
        for(NSDictionary *json in [attributes arrayForKey:KEY_COLORS]) {
            if([json isKindOfClass:klass]) {
                MFColor *color = [[MFColor alloc] initWithAttributes:json];
                
                if(color) {
                    if(!colors) {
                        colors = [NSMutableArray array];
                    }
                    
                    [colors addObject:color];
                }
            }
        }
        
        for(NSDictionary *json in [attributes arrayForKey:KEY_COUNTRIES]) {
            if([json isKindOfClass:klass]) {
                MFCountry *country = [[MFCountry alloc] initWithAttributes:json];
                
                if(country) {
                    if(!countries) {
                        countries = [NSMutableArray array];
                    }
                    
                    [countries addObject:country];
                }
            }
        }
        
        for(NSDictionary *json in [attributes arrayForKey:KEY_DELIVERIES]) {
            if([json isKindOfClass:klass]) {
                MFDelivery *delivery = [[MFDelivery alloc] initWithAttributes:json];
                
                if(delivery) {
                    if(!deliveries) {
                        deliveries = [NSMutableArray array];
                    }
                    
                    [deliveries addObject:delivery];
                }
            }
        }
        
        for(NSDictionary *json in [attributes arrayForKey:KEY_SIZES]) {
            if([json isKindOfClass:klass]) {
                MFSize *size = [[MFSize alloc] initWithAttributes:json];
                
                if(size) {
                    if(!sizes) {
                        sizes = [NSMutableArray array];
                    }
                    
                    [sizes addObject:size];
                }
            }
        }
        
        for(NSDictionary *json in [attributes arrayForKey:KEY_TYPES]) {
            if([json isKindOfClass:klass]) {
                MFType *type = [[MFType alloc] initWithAttributes:json];
                
                if(type) {
                    if(!types) {
                        types = [NSMutableArray array];
                    }
                    
                    [types addObject:type];
                }
            }
        }
        
        m_changes = [attributes arrayForKey:KEY_CHANGES];
        m_cursor = ([cursor isEqualToString:@"end"]) ? kMFFeedCursorEnd : (([cursor isEqualToString:@"middle"]) ? kMFFeedCursorMiddle : kMFFeedCursorStart);
        m_currencies = currencies;
        m_prefix = (prefix) ? [NSURL URLWithString:prefix] : nil;
        m_globals = [attributes stringForKey:KEY_GLOBALS];
        m_posts = posts;
        m_brands = brands;
        m_colors = colors;
        m_countries = countries;
        m_deliveries = deliveries;
        m_sizes = sizes;
        m_types = types;
        m_state = [attributes stringForKey:KEY_STATE];
        m_offset = [attributes integerForKey:KEY_OFFSET];
    }
    
    return self;
}

- (id)initWithFeed:(MFFeed *)feed offset:(NSInteger)offset
{
    return [self initWithState:feed.state cursor:feed.cursor offset:offset];
}

- (id)initWithState:(NSString *)state cursor:(MFFeedCursor)cursor offset:(NSInteger)offset
{
    self = [super init];
    
    if(self) {
        m_state = state;
        m_cursor = cursor;
        m_offset = offset;
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    if(m_state) {
        [attributes setValue:m_state forKey:KEY_STATE];
    }
    
    if(m_offset != 0) {
        [attributes setValue:[NSNumber numberWithInteger:m_offset] forKey:KEY_OFFSET];
    }
    
    if(m_cursor != kMFFeedCursorStart) {
        [attributes setValue:(m_cursor == kMFFeedCursorMiddle) ? @"middle" : @"end" forKey:KEY_CURSOR];
    }
    
    if(m_prefix) {
        [attributes setValue:m_prefix.absoluteString forKey:KEY_PREFIX];
    }
    
    return attributes;
}

@synthesize brands = m_brands;
@synthesize changes = m_changes;
@synthesize countries = m_countries;
@synthesize deliveries = m_deliveries;
@synthesize offset = m_offset;
@synthesize colors = m_colors;
@synthesize cursor = m_cursor;
@synthesize currencies = m_currencies;
@synthesize prefix = m_prefix;
@synthesize globals = m_globals;
@synthesize posts = m_posts;
@synthesize sizes = m_sizes;
@synthesize types = m_types;
@synthesize state = m_state;

#pragma mark MFWebRequestTransform

+ (id)parseFromObject:(id)object
{
    return ([object isKindOfClass:[NSDictionary class]]) ? [[self alloc] initWithAttributes:(NSDictionary *)object] : nil;
}

#pragma mark NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ / %d / %d", m_state, m_cursor, m_offset];
}

@end