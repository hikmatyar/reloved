/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequestTransform.h"

typedef enum _MFFeedCursor {
    kMFFeedCursorStart = 0,
    kMFFeedCursorMiddle,
    kMFFeedCursorEnd
} MFFeedCursor;

@interface MFFeed : NSObject <MFWebRequestTransform>
{
    @private
    NSArray *m_brands;
    NSArray *m_changes;
    NSArray *m_colors;
    NSArray *m_countries;
    MFFeedCursor m_cursor;
    NSArray *m_currencies;
    NSArray *m_deliveries;
    NSArray *m_events;
    NSArray *m_posts;
    NSString *m_globals;
    NSURL *m_prefix;
    NSArray *m_sizes;
    NSString *m_state;
    NSArray *m_types;
    NSInteger m_offset;
}

- (id)initWithAttributes:(NSDictionary *)attributes;
- (id)initWithFeed:(MFFeed *)feed offset:(NSInteger)offset;
- (id)initWithState:(NSString *)state cursor:(MFFeedCursor)cursor offset:(NSInteger)offset;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, retain, readonly) NSArray *brands;
@property (nonatomic, retain, readonly) NSArray *changes;
@property (nonatomic, retain, readonly) NSArray *colors;
@property (nonatomic, retain, readonly) NSArray *deliveries;
@property (nonatomic, assign, readonly) NSInteger offset;
@property (nonatomic, retain, readonly) NSArray *countries;
@property (nonatomic, assign, readonly) MFFeedCursor cursor;
@property (nonatomic, retain, readonly) NSArray *currencies;
@property (nonatomic, retain, readonly) NSArray *events;
@property (nonatomic, retain, readonly) NSArray *posts;
@property (nonatomic, retain, readonly) NSString *globals;
@property (nonatomic, retain, readonly) NSURL *prefix;
@property (nonatomic, retain, readonly) NSArray *sizes;
@property (nonatomic, retain, readonly) NSString *state;
@property (nonatomic, retain, readonly) NSArray *types;

@end
