/* Copyright (c) 2013 Meep Factory OU */

#import "MFApplicationDelegate.h"
#import "MFHomeController.h"
#import "MFMenuController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFWebController.h"

@implementation MFApplicationDelegate

@synthesize window = m_window;

#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MFSideMenuContainerViewController *controller = [MFSideMenuContainerViewController
        containerWithCenterViewController:[[UINavigationController alloc] initWithRootViewController:[[MFHomeController alloc] init]]
        leftMenuViewController:[[MFMenuController alloc] init]
        rightMenuViewController:nil];
    
    m_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    m_window.rootViewController = controller;
    [m_window makeKeyAndVisible];
    
    [MFWebController preload];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

@end
