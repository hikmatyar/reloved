/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequestTransform.h"

typedef enum _MFFeedCursor {
    kMFFeedCursorStart = 0,
    kMFFeedCursorMiddle,
    kMFFeedCursorEnd
} MFFeedCursor;

@interface MFFeed : NSObject
{
    @private
    NSArray *m_changes;
    NSArray *m_colors;
    MFFeedCursor m_cursor;
    NSArray *m_currencies;
    NSArray *m_posts;
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

@property (nonatomic, retain, readonly) NSArray *changes;
@property (nonatomic, retain, readonly) NSArray *colors;
@property (nonatomic, assign, readonly) NSInteger offset;
@property (nonatomic, assign, readonly) MFFeedCursor cursor;
@property (nonatomic, retain, readonly) NSArray *currencies;
@property (nonatomic, retain, readonly) NSArray *posts;
@property (nonatomic, retain, readonly) NSURL *prefix;
@property (nonatomic, retain, readonly) NSArray *sizes;
@property (nonatomic, retain, readonly) NSString *state;
@property (nonatomic, retain, readonly) NSArray *types;

@end
