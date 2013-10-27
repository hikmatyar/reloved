/* Copyright (c) 2013 Meep Factory OU */

#import "MFApplicationDelegate.h"
#import "MFHomeController.h"
#import "MFMenuController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFWebAuthorization.h"
#import "MFWebController.h"
#import "MFWebFeed.h"
#import "MFWebService.h"
#import "MFWebServiceAuthenticationChallenge.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UINavigationController+Additions.h"

#define EVENT_CATEGORY @"application"
#define EVENT_ACTION_LAUNCH @"launch"

@implementation MFApplicationDelegate

@synthesize window = m_window;

#pragma mark MFWebServiceDelegate

- (void)webService:(MFWebService *)webService authenticationChallenge:(id <MFWebServiceAuthenticationChallenge>)challenge
{
    if(challenge.failureCount > 3) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Reachability.Title.NoConnection", nil)
                                                            message:NSLocalizedString(@"Reachability.Message.NoConnection", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Reachability.Action.Cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"Reachability.Action.TryAgain", nil), nil];
        
        [alertView show];
    } else {
        [challenge useAuthorization:[MFWebAuthorization authorizationForDeviceID:[UIDevice currentDevice].identifierForVendor.UUIDString]];
    }
}

- (void)webServiceDidLogin:(MFWebService *)webService
{
    MFDebug(@"did login");
}

- (void)webServiceDidLogout:(MFWebService *)webService
{
    MFDebug(@"did logout");
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex) {
        [[MFWebService sharedService].challenge useAuthorization:[MFWebAuthorization authorizationForDeviceID:[UIDevice currentDevice].identifierForVendor.UUIDString]];
    } else {
        [[MFWebService sharedService].challenge abortAuthorization];
    }
}

#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    MFSideMenuContainerViewController *controller = [MFSideMenuContainerViewController
        containerWithCenterViewController:[[UINavigationController alloc] initWithRootViewController:[[MFHomeController alloc] init]]
        leftMenuViewController:[[MFMenuController alloc] init]
        rightMenuViewController:nil];
    
    // This is needed only because iOS 7.0 has a nasty rendering bug with tableviews without it. Relevant since iOS 7 june betas. Why wasn't it fixed in GM? Beats me! -- JP
    ((UINavigationController *)controller.centerViewController).navigationBar.translucent = NO;
    
    // Navigation title font
    [[UINavigationBar appearance] setTitleTextAttributes:
        [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeFontOfSize:14.0F], UITextAttributeFont, nil]];
    
    // Navigation button font
    [[UIBarButtonItem appearance] setTitleTextAttributes:
        [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeFontOfSize:14.0F], UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    [MFWebService sharedService].delegate = self;
    m_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    m_window.rootViewController = controller;
    [m_window makeKeyAndVisible];
    
    [MFWebController preload];
    
    if(url) {
        [controller.centerViewController pushLink:url animated:NO];
    }
    
    LOG_EVENT(EVENT_CATEGORY, EVENT_ACTION_LAUNCH);
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[MFWebFeed sharedFeed] loadForward];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    UIViewController *controller = m_window.rootViewController;
    
    return ([controller isKindOfClass:[MFSideMenuContainerViewController class]]) ? [((MFSideMenuContainerViewController *)controller).centerViewController pushLink:url animated:NO] : NO;
}

@end
