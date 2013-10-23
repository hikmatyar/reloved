/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFNotice : NSObject
{
    @private
    NSString *m_title;
    NSString *m_subject;
    NSString *m_message;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, retain, readonly) NSString *title;
@property (nonatomic, retain, readonly) NSString *subject;
@property (nonatomic, retain, readonly) NSString *message;

@end
