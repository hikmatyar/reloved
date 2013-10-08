/* Copyright (c) 2013 Meep Factory OU */

#import "MFForm.h"
#import "MFFormAccessory.h"
#import "MFFormButton.h"
#import "MFFormLabel.h"
#import "MFFormTextField.h"
#import "MFNewPostController+Details.h"
#import "MFNewPostPageView.h"
#import "MFOptionPickerController.h"
#import "MFOptionPickerControllerDelegate.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+Additions.h"

@interface MFNewPostController_Details : MFNewPostPageView <MFOptionPickerControllerDelegate, UITextFieldDelegate>
{
    @private
    MFFormAccessory *m_accessory;
    BOOL m_canContinue;
    MFFormButton *m_brandButton;
    MFFormButton *m_colorsButton;
    MFFormTextField *m_materialsTextField;
    MFForm *m_form;
}

@end

@implementation MFNewPostController_Details

- (IBAction)brand:(id)sender
{
    MFOptionPickerController *controller = [[MFOptionPickerController alloc] init];
    
    controller.delegate = self;
    [m_controller presentNavigableViewController:controller animated:YES completion:NULL];
}

- (IBAction)colors:(id)sender
{
    MFOptionPickerController *controller = [[MFOptionPickerController alloc] init];
    
    controller.delegate = self;
    controller.allowsMultipleSelection = YES;
    [m_controller presentNavigableViewController:controller animated:YES completion:NULL];
}

#pragma mark MFNewPostPageView

- (id)initWithFrame:(CGRect)frame controller:(MFNewPostController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
        MFFormLabel *label;
        
        m_form = [[MFForm alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        m_form.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:m_form];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"NewPost.Label.Materials", nil);
        [m_form addSubview:label];
        
        m_materialsTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_materialsTextField.delegate = self;
        m_materialsTextField.returnKeyType = UIReturnKeyDone;
        m_materialsTextField.placeholder = NSLocalizedString(@"NewPost.Hint.Materials", nil);
        [m_form addSubview:m_materialsTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"NewPost.Label.Colors", nil);
        [m_form addSubview:label];
        
        m_colorsButton = [[MFFormButton alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormButton preferredHeight])];
        m_colorsButton.placeholder = NSLocalizedString(@"NewPost.Hint.Colors", nil);
        [m_colorsButton addTarget:self action:@selector(colors:) forControlEvents:UIControlEventTouchUpInside];
        [m_colorsButton setTitle:@"Black, Purple" forState:UIControlStateNormal];
        [m_form addSubview:m_colorsButton];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"NewPost.Label.Brand", nil);
        [m_form addSubview:label];
        
        m_brandButton = [[MFFormButton alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormButton preferredHeight])];
        m_brandButton.placeholder = NSLocalizedString(@"NewPost.Hint.Brand", nil);
        [m_brandButton addTarget:self action:@selector(brand:) forControlEvents:UIControlEventTouchUpInside];
        [m_brandButton setTitle:@"Gucci" forState:UIControlStateNormal];
        [m_form addSubview:m_brandButton];
        
        m_accessory = [[MFFormAccessory alloc] initWithContext:m_form];
    }
    
    return self;
}

- (BOOL)canContinue
{
    if(!m_canContinue) {
        m_canContinue = (m_materialsTextField.text.length > 0 && !m_brandButton.empty && !m_colorsButton.empty) ? YES : NO;
    }
    
    return m_canContinue;
}

#pragma mark MFOptionPickerControllerDelegate

- (void)optionPickerControllerDidComplete:(MFOptionPickerController *)controller
{
    // TODO:
    [m_controller invalidateNavigation];
}

#pragma mark MFPageView

- (void)pageWillAppear
{
    [m_accessory activate];
}

- (void)pageWillDisappear
{
    [m_materialsTextField resignFirstResponder];
    //[m_accessory deactivate];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_materialsTextField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [m_form scrollToView:textField animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [m_controller invalidateNavigation];
}

@end

#pragma mark -

@implementation MFNewPostController(Details)

- (MFNewPostPageView *)createDetailsPageView
{
    return [[MFNewPostController_Details alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
