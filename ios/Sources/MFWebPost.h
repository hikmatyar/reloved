/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFPost;

@interface MFWebPost : NSObject
{
    @private
    NSString *m_identifier;
    MFPost *m_post;
}

- (id)initWithIdentifier:(NSString *)identifier;
- (id)initWithPost:(MFPost *)post;

@end
