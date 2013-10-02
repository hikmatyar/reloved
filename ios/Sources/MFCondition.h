/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFCondition : NSObject
{
    @private
    NSString *m_identifier;
    NSString *m_title;
    NSArray *m_comments;
}

+ (NSArray *)allConditions;

- (id)initWithIdentifier:(NSString *)identifier title:(NSString *)title comments:(NSArray *)comments;

@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, retain, readonly) NSString *title;
@property (nonatomic, retain, readonly) NSArray *comments;

@end
