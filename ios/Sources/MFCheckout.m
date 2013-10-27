/* Copyright (c) 2013 Meep Factory OU */

#import "MFCheckout.h"
#import "MFCountry.h"
#import "MFDelivery.h"
#import "MFMoney.h"
#import "MFPost.h"
#import "MFUserDetails.h"
#import "NSDictionary+Additions.h"

#define KEY_COUNTRIES @"countries"
#define KEY_DELIVERIES @"deliveries"
#define KEY_FEES @"fees"
#define KEY_POSTS @"posts"
#define KEY_USER @"user"
#define KEY_STATUS @"status"

@implementation MFCheckout

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        Class klass = [NSDictionary class];
        NSMutableArray *countries = nil;
        NSMutableArray *deliveries = nil;
        NSMutableArray *posts = nil;
        
        m_user = [[MFUserDetails alloc] initWithAttributes:[attributes dictionaryForKey:KEY_USER]];
        m_fees = [attributes dictionaryForKey:KEY_FEES];
        m_status = [attributes integerForKey:KEY_STATUS];
        
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
        
        m_countries = countries;
        m_deliveries = deliveries;
        m_posts = posts;
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setValue:m_user.attributes forKey:KEY_USER];
    [attributes setValue:m_fees forKey:KEY_FEES];
    [attributes setValue:[NSNumber numberWithInteger:m_status] forKey:KEY_STATUS];
    
    if(m_countries) {
        NSMutableArray *countries = [[NSMutableArray alloc] init];
        
        for(MFCountry *country in m_countries) {
            [countries addObject:country.attributes];
        }
        
        [attributes setValue:countries forKey:KEY_COUNTRIES];
    }
    
    if(m_deliveries) {
        NSMutableArray *deliveries = [[NSMutableArray alloc] init];
        
        for(MFDelivery *delivery in m_deliveries) {
            [deliveries addObject:delivery.attributes];
        }
        
        [attributes setValue:deliveries forKey:KEY_DELIVERIES];
    }
    
    if(m_posts) {
        NSMutableArray *posts = [[NSMutableArray alloc] init];
        
        for(MFPost *post in m_posts) {
            [posts addObject:post.attributes];
        }
        
        [attributes setValue:posts forKey:KEY_POSTS];
    }
    
    return attributes;
}

- (MFMoney *)feeForCurrency:(NSString *)currency
{
    return (currency) ? [[MFMoney alloc] initWithValue:[m_fees numberForKey:currency].integerValue currency:currency] : nil;
}

@synthesize status = m_status;
@synthesize countries = m_countries;
@synthesize deliveries = m_deliveries;
@synthesize posts = m_posts;
@synthesize user = m_user;

#pragma mark MFWebRequestTransform

+ (id)parseFromObject:(id)object
{
    return ([object isKindOfClass:[NSDictionary class]]) ? [[self alloc] initWithAttributes:(NSDictionary *)object] : nil;
}

@end
