/* Copyright (c) 2013 Meep Factory OU */

#import "UIViewController+Additions.h"

@implementation UIViewController(Additions)

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)presentNavigableViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerToPresent];
    
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navigationController.navigationBar.translucent = NO;
    
    if(!viewControllerToPresent.navigationItem.rightBarButtonItem) {
        viewControllerToPresent.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss:)];
    }
    
    [self presentViewController:navigationController animated:flag completion:completion];
}

@end
