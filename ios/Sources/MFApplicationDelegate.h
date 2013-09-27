/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebServiceDelegate.h"

@interface MFApplicationDelegate : UIResponder <MFWebServiceDelegate, UIAlertViewDelegate, UIApplicationDelegate>
{
    @private
    UIWindow *m_window;
}

@property (strong, nonatomic) UIWindow *window;

@end
