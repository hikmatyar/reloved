/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFComment : NSObject
{
    @private
    NSString *m_identifier;
    NSString *m_userId;
    NSDate *m_date;
    NSDate *m_modified;
    NSString *m_message;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, retain, readonly) NSString *userId;
@property (nonatomic, retain, readonly) NSDate *date;
@property (nonatomic, retain, readonly) NSDate *modified;
@property (nonatomic, retain, readonly) NSString *message;

@end
