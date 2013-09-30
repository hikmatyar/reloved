/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFPreferences : NSObject
{
    @private
    NSArray *m_bookmarks;
    NSInteger m_category;
    NSArray *m_sizes;
    NSArray *m_types;
}

+ (MFPreferences *)sharedPreferences;

@property (nonatomic, retain) NSArray *bookmarks;
@property (nonatomic, assign) NSInteger category;
@property (nonatomic, retain) NSArray *sizes;
@property (nonatomic, retain) NSArray *types;

@end
