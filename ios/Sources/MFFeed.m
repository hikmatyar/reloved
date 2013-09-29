/* Copyright (c) 2013 Meep Factory OU */

#import "MFCurrency.h"
#import "MFFeed.h"
#import "MFPost.h"
#import "NSDictionary+Additions.h"

#define KEY_CHANGES @"changes"
#define KEY_CURSOR @"cursor"
#define KEY_CURRENCIES @"currencies"
#define KEY_PREFIX @"prefix"
#define KEY_POSTS @"posts"
#define KEY_STATE @"state"
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
        
        m_changes = [attributes arrayForKey:KEY_CHANGES];
        m_cursor = ([cursor isEqualToString:@"end"]) ? kMFFeedCursorEnd : (([cursor isEqualToString:@"middle"]) ? kMFFeedCursorMiddle : kMFFeedCursorStart);
        m_currencies = currencies;
        m_prefix = (prefix) ? [NSURL URLWithString:prefix] : nil;
        m_posts = posts;
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

@synthesize changes = m_changes;
@synthesize offset = m_offset;
@synthesize cursor = m_cursor;
@synthesize currencies = m_currencies;
@synthesize prefix = m_prefix;
@synthesize posts = m_posts;
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