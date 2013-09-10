/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFApplicationDelegate : UIResponder <UIApplicationDelegate>
{
    @private
    UIWindow *m_window;
}

@property (strong, nonatomic) UIWindow *window;

@end
