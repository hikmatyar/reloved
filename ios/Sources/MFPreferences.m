/* Copyright (c) 2013 Meep Factory OU */

#import "MFPreferences.h"

#define KEY_BOOKMARKS @"bookmarks"
#define KEY_CATEGORY @"category"
#define KEY_EXCLUDE_COLORS @"excludeColors"
#define KEY_EXCLUDE_SIZES @"excludeSizes"
#define KEY_EXCLUDE_TYPES @"excludeTypes"

@implementation MFPreferences

+ (MFPreferences *)sharedPreferences
{
    __strong static MFPreferences *sharedPreferences = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        sharedPreferences = [[self alloc] init];
    });
    
    return sharedPreferences;
}

@dynamic bookmarks;

- (NSArray *)bookmarks
{
    return m_bookmarks;
}

- (void)setBookmarks:(NSArray *)bookmarks
{
    if(!MFEqual(m_bookmarks, bookmarks)) {
        m_bookmarks = bookmarks;
        [[NSUserDefaults standardUserDefaults] setObject:m_bookmarks forKey:KEY_BOOKMARKS];
    }
}

@dynamic category;

- (NSInteger)category
{
    return m_category;
}

- (void)setCategory:(NSInteger)category
{
    if(m_category != category) {
        m_category = category;
        [[NSUserDefaults standardUserDefaults] setInteger:m_category forKey:KEY_CATEGORY];
    }
}

@dynamic excludeColors;

- (NSArray *)excludeColors
{
    return m_excludeColors;
}

- (void)setExcludeColors:(NSArray *)excludeColors
{
    if(!MFEqual(m_excludeColors, excludeColors)) {
        m_excludeColors = excludeColors;
        [[NSUserDefaults standardUserDefaults] setObject:m_excludeColors forKey:KEY_EXCLUDE_COLORS];
    }
}

@dynamic excludeSizes;

- (NSArray *)excludeSizes
{
    return m_excludeSizes;
}

- (void)setExcludeSizes:(NSArray *)excludeSizes
{
    if(!MFEqual(m_excludeSizes, excludeSizes)) {
        m_excludeSizes = excludeSizes;
        [[NSUserDefaults standardUserDefaults] setObject:m_excludeSizes forKey:KEY_EXCLUDE_SIZES];
    }
}

@dynamic excludeTypes;

- (NSArray *)excludeTypes
{
    return m_excludeTypes;
}

- (void)setExcludeTypes:(NSArray *)excludeTypes
{
    if(!MFEqual(m_excludeTypes, excludeTypes)) {
        m_excludeTypes = excludeTypes;
        [[NSUserDefaults standardUserDefaults] setObject:m_excludeTypes forKey:KEY_EXCLUDE_TYPES];
    }
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        m_bookmarks = [defaults arrayForKey:KEY_BOOKMARKS];
        m_category = [defaults integerForKey:KEY_CATEGORY];
        m_excludeColors = [defaults arrayForKey:KEY_EXCLUDE_COLORS];
        m_excludeSizes = [defaults arrayForKey:KEY_EXCLUDE_SIZES];
        m_excludeTypes = [defaults arrayForKey:KEY_EXCLUDE_TYPES];
    }
    
    return self;
}

@end
