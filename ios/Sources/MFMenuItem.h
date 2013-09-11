/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

typedef void (*MFMenuItemAction)(id target, SEL sel, id sender);

#define MENU_ITEM(t, s, i) [[MFMenuItem alloc] initWithTitle:t selector:s image:i]

@interface MFMenuItem : NSObject
{
    @private
    NSString *m_image;
    SEL m_selector;
    NSString *m_title;
}

- (id)initWithTitle:(NSString *)title selector:(SEL)selector image:(NSString *)image;

@property (nonatomic, retain) NSString *image;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, retain) NSString *title;

@end
