/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFPreferences : NSObject
{
    @private
    NSArray *m_bookmarks;
    NSArray *m_cart;
    NSInteger m_category;
    NSArray *m_excludeColors;
    NSArray *m_excludeSizes;
    NSArray *m_excludeTypes;
}

+ (MFPreferences *)sharedPreferences;

@property (nonatomic, retain) NSArray *bookmarks;
@property (nonatomic, retain) NSArray *cart;
@property (nonatomic, assign) NSInteger category;
@property (nonatomic, retain) NSArray *excludeColors;
@property (nonatomic, retain) NSArray *excludeSizes;
@property (nonatomic, retain) NSArray *excludeTypes;

@end
