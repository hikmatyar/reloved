/* Copyright (c) 2013 Meep Factory OU */

#import "MFPreferences.h"

#define KEY_BOOKMARKS @"bookmarks"
#define KEY_SIZES @"sizes"
#define KEY_TYPES @"types"

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

@dynamic sizes;

- (NSArray *)sizes
{
    return m_sizes;
}

- (void)setSizes:(NSArray *)sizes
{
    if(!MFEqual(m_sizes, sizes)) {
        m_sizes = sizes;
        [[NSUserDefaults standardUserDefaults] setObject:m_sizes forKey:KEY_SIZES];
    }
}

@dynamic types;

- (NSArray *)types
{
    return m_types;
}

- (void)setTypes:(NSArray *)types
{
    if(!MFEqual(m_types, types)) {
        m_types = types;
        [[NSUserDefaults standardUserDefaults] setObject:m_types forKey:KEY_TYPES];
    }
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        m_bookmarks = [defaults arrayForKey:KEY_BOOKMARKS];
        m_sizes = [defaults arrayForKey:KEY_SIZES];
        m_types = [defaults arrayForKey:KEY_TYPES];
    }
    
    return self;
}

@end
