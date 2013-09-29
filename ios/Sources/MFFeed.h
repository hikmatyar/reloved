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
    MFFeedCursor m_cursor;
    NSArray *m_currencies;
    NSArray *m_posts;
    NSURL *m_prefix;
    NSString *m_state;
    NSInteger m_offset;
}

- (id)initWithAttributes:(NSDictionary *)attributes;
- (id)initWithFeed:(MFFeed *)feed offset:(NSInteger)offset;
- (id)initWithState:(NSString *)state cursor:(MFFeedCursor)cursor offset:(NSInteger)offset;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, retain, readonly) NSArray *changes;
@property (nonatomic, assign, readonly) NSInteger offset;
@property (nonatomic, assign, readonly) MFFeedCursor cursor;
@property (nonatomic, retain, readonly) NSArray *currencies;
@property (nonatomic, retain, readonly) NSArray *posts;
@property (nonatomic, retain, readonly) NSURL *prefix;
@property (nonatomic, retain, readonly) NSString *state;

@end
