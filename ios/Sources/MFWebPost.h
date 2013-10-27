/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@class MFBrand, MFCondition, MFPost, MFSize;

extern NSString *MFWebPostChangesKey;
extern NSString *MFWebPostErrorKey;

extern NSString *MFWebPostDidBeginLoadingNotification;
extern NSString *MFWebPostDidEndLoadingNotification;
extern NSString *MFWebPostDidChangeNotification;
extern NSString *MFWebPostDidDeleteNotification;

@interface MFWebPost : NSObject
{
    @private
    BOOL m_loading;
    NSString *m_identifier;
    MFPost *m_post;
    NSArray *m_comments;
    NSString *m_state;
}

- (id)initWithIdentifier:(NSString *)identifier;
- (id)initWithPost:(MFPost *)post;

@property (nonatomic, retain, readonly) MFBrand *brand;
@property (nonatomic, retain, readonly) NSArray *colors;
@property (nonatomic, retain, readonly) MFCondition *condition;
@property (nonatomic, retain, readonly) NSArray *comments;
@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, retain, readonly) MFPost *post;
@property (nonatomic, retain, readonly) MFSize *size;
@property (nonatomic, retain, readonly) NSArray *types;
@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;

@property (nonatomic, assign, getter = isMine) BOOL mine;
@property (nonatomic, assign, getter = isLoaded) BOOL loaded;
@property (nonatomic, assign, getter = isSaved) BOOL saved;
@property (nonatomic, assign) BOOL includedInCart;

- (void)startLoading;
- (void)stopLoading;
- (void)reloadData;
- (void)delete;

@end
