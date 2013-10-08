/* Copyright (c) 2013 Meep Factory OU */

#import "UIViewController+Additions.h"

@implementation UIViewController(Additions)

- (void)presentNavigableViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerToPresent];
    
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navigationController.navigationBar.translucent = NO;
    
    [self presentViewController:navigationController animated:flag completion:completion];
}

@end
