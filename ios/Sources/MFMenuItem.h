/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

typedef void (*MFMenuItemAction)(id target, SEL sel, id sender);

#define MENU_ITEM(t, s, i) [[MFMenuItem alloc] initWithTitle:t image:i selector:s]

@interface MFMenuItem : NSObject
{
    @private
    NSString *m_image;
    SEL m_selector;
    NSString *m_title;
}

- (id)initWithTitle:(NSString *)title image:(NSString *)image selector:(SEL)selector;

@property (nonatomic, retain) NSString *image;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, retain) NSString *title;

- (void)activate:(id)target;

@end
