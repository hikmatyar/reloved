/* Copyright (c) 2013 Meep Factory OU */

#import "MFApplicationDelegate.h"
#import "MFHomeController.h"
#import "MFMenuController.h"
#import "MFSideMenuContainerViewController.h"

@implementation MFApplicationDelegate

@synthesize window = m_window;

#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MFSideMenuContainerViewController *controller = [MFSideMenuContainerViewController
        containerWithCenterViewController:[[UINavigationController alloc] initWithRootViewController:[[MFHomeController alloc] init]]
        leftMenuViewController:[[MFMenuController alloc] init]
        rightMenuViewController:[[MFMenuController alloc] init]];
    
    m_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    m_window.rootViewController = controller;
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
