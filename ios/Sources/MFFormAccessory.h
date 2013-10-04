/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFFormAccessory : NSObject
{
    @private
    UIScrollView *m_context;
}

+ (BOOL)isVisible;

- (id)initWithContext:(UIScrollView *)context;

- (void)activate;
- (void)deactivate;

@end
