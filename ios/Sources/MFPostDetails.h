/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequestTransform.h"

@class MFPost, MFUser;

@interface MFPostDetails : NSObject <MFWebRequestTransform>
{
    @private
    NSArray *m_comments;
    MFPost *m_post;
    NSArray *m_users;
    NSString *m_state;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, retain, readonly) MFUser *author;
@property (nonatomic, retain, readonly) NSArray *comments;
@property (nonatomic, retain, readonly) MFPost *post;
@property (nonatomic, retain, readonly) NSArray *users;
@property (nonatomic, retain, readonly) NSString *state;

@end
