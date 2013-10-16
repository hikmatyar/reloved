/* Copyright (c) 2013 Meep Factory OU */

#import <MessageUI/MessageUI.h>
#import "UIApplication+Additions.h"

@implementation UIApplication (Additions)

- (void)sendEmail:(NSString *)email
{
    [self sendEmail:email subject:nil body:nil];
}

- (void)sendEmail:(NSString *)email subject:(NSString *)subject body:(NSString *)body
{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        
        picker.mailComposeDelegate = (id <MFMailComposeViewControllerDelegate>)self;
        picker.subject = subject;
        
        if(body) {
            [picker setMessageBody:body isHTML:NO];
        }
        
        if(email) {
            [picker setToRecipients:[NSArray arrayWithObject:email]];
        }
        
        [self.keyWindow.rootViewController presentViewController:picker animated:YES completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Email.Error.Title", nil)
                                                        message:NSLocalizedString(@"Email.Error.Message", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Email.Error.Action.OK", nil)
                                              otherButtonTitles:nil];
        
        [alert show];
    }
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error 
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
