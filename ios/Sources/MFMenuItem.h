/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

typedef void (*MFMenuItemAction)(id target, SEL sel, id sender);

#define MENU_ITEM(t, s, i) [[MFMenuItem alloc] initWithTitle:t subtitle:nil image:i selector:s]
#define MENU_ITEM_SUB(t, n, s, i) [[MFMenuItem alloc] initWithTitle:t subtitle:n image:i selector:s]

@interface MFMenuItem : NSObject
{
    @private
    NSString *m_image;
    SEL m_selector;
    NSString *m_title;
    NSString *m_subtitle;
}

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(NSString *)image selector:(SEL)selector;

@property (nonatomic, retain) NSString *image;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;

- (void)activate:(id)target;

@end
