/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

typedef enum _MFEventType {
    kMFEventTypePurchased = 1,
    kMFEventTypeComment = 2
} MFEventType;

@interface MFEvent : NSObject
{
    @private
    NSDate *m_date;
    NSString *m_identifier;
    NSString *m_link;
    NSArray *m_meta;
    MFEventType m_type;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, retain, readonly) NSDate *date;
@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, retain, readonly) NSString *link;
@property (nonatomic, retain, readonly) NSArray *meta;
@property (nonatomic, assign, readonly) MFEventType type;

@end
