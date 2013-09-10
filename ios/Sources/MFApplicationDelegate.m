/* Copyright (c) 2013 Meep Factory OU */

#import "MFApplicationDelegate.h"
#import "MFFeedController.h"

@implementation MFApplicationDelegate

@synthesize window = m_window;

#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[MFFeedController alloc] init]];
    
    m_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    m_window.rootViewController = navigationController;
    [m_window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

@end
