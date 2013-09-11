/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

#define MENU_SECTION(t, c, ...) [[MFMenu alloc] initWithTitle:t children:[[NSArray alloc] initWithObjects:c, ##__VA_ARGS__, nil]]

@class MFMenuItem;

@interface MFMenu : NSObject
{
    @private
    NSString *m_title;
    NSArray *m_children;
}

- (id)initWithTitle:(NSString *)title children:(NSArray *)children;

@property (nonatomic, retain, readonly) NSString *title;
@property (nonatomic, retain, readonly) NSArray *children;
@property (nonatomic, assign, readonly) NSInteger count;

- (MFMenuItem *)objectAtIndex:(NSInteger)index;

@end
