/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

typedef void (*MFMenuItemAction)(id target, SEL sel, id sender);

#define MENU_ITEM(t, s, i) [[MFMenuItem alloc] initWithTitle:t subtitle:nil image:i selector:s highlight:NO]
#define MENU_ITEM_ALT(t, s, i) [[MFMenuItem alloc] initWithTitle:t subtitle:nil image:i selector:s highlight:YES]
#define MENU_ITEM_SUB(t, n, s, i) [[MFMenuItem alloc] initWithTitle:t subtitle:n image:i selector:s highlight:NO]

@interface MFMenuItem : NSObject
{
    @private
    BOOL m_highlight;
    NSString *m_image;
    SEL m_selector;
    NSString *m_title;
    NSString *m_subtitle;
}

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(NSString *)image selector:(SEL)selector highlight:(BOOL)highlight;

@property (nonatomic, retain) NSString *image;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) BOOL highlight;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;

- (void)activate:(id)target;

@end
