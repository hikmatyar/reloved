/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFUser : NSObject
{
    @private
    NSString *m_identifier;
    NSString *m_media;
    NSString *m_name;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, retain, readonly) NSString *media;
@property (nonatomic, retain, readonly) NSString *name;

@end
