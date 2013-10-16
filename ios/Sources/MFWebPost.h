/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFBrand, MFCondition, MFPost, MFSize;

@interface MFWebPost : NSObject
{
    @private
    NSString *m_identifier;
    MFPost *m_post;
}

- (id)initWithIdentifier:(NSString *)identifier;
- (id)initWithPost:(MFPost *)post;

@property (nonatomic, retain, readonly) MFBrand *brand;
@property (nonatomic, retain, readonly) NSArray *colors;
@property (nonatomic, retain, readonly) MFCondition *condition;
@property (nonatomic, retain, readonly) MFPost *post;
@property (nonatomic, retain, readonly) MFSize *size;
@property (nonatomic, retain, readonly) NSArray *types;

@property (nonatomic, assign, getter = isSaved) BOOL saved;
@property (nonatomic, assign) BOOL insideCart;

@end
