/* Copyright (c) 2013 Meep Factory OU */

#import "MFForm.h"
#import "MFFormAccessory.h"
#import "MFFormButton.h"
#import "MFFormLabel.h"
#import "MFFormTextField.h"
#import "MFProfileController.h"

@implementation MFProfileController

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)done:(id)sender
{
}

#pragma mark UIViewController

- (void)loadView
{
    
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profile.Action.Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profile.Action.Done", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
        self.title = NSLocalizedString(@"Profile.Title", nil);
    }
    
    return self;
}

@end
