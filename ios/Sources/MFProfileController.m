/* Copyright (c) 2013 Meep Factory OU */

#import "MFForm.h"
#import "MFFormAccessory.h"
#import "MFFormButton.h"
#import "MFFormFooter.h"
#import "MFFormLabel.h"
#import "MFFormTextField.h"
#import "MFFormTextView.h"
#import "MFProfileController.h"
#import "UIColor+Additions.h"

#define TAG_FORM 1000

@implementation MFProfileController

- (MFForm *)form
{
    return (MFForm *)[self.view viewWithTag:TAG_FORM];
}

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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    MFForm *form = [[MFForm alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    MFFormTextField *textField;
    MFFormTextView *textView;
    MFFormFooter *footer;
    MFFormLabel *label;
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.FullName", nil);
    [form addSubview:label];
    
    textField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyNext;
    textField.placeholder = NSLocalizedString(@"Profile.Hint.FullName", nil);
    [form addSubview:textField];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.AddressLine", nil);
    [form addSubview:label];
    
    textView = [[MFFormTextView alloc] initWithFrame:CGRectMake(10.0F, 220.0F, 300.0F, 2.0F * [MFFormLabel preferredHeight])];
    textView.delegate = self;
    textView.placeholder = NSLocalizedString(@"Profile.Hint.AddressLine", nil);
    [form addSubview:textView];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.Country", nil);
    [form addSubview:label];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.City", nil);
    [form addSubview:label];
    
    textField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyNext;
    textField.placeholder = NSLocalizedString(@"Profile.Hint.City", nil);
    [form addSubview:textField];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.Postcode", nil);
    [form addSubview:label];
    
    textField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyNext;
    textField.placeholder = NSLocalizedString(@"Profile.Hint.Postcode", nil);
    [form addSubview:textField];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.Phone", nil);
    [form addSubview:label];
    
    textField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyNext;
    textField.placeholder = NSLocalizedString(@"Profile.Hint.Phone", nil);
    [form addSubview:textField];
    
    label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
    label.text = NSLocalizedString(@"Profile.Label.Email", nil);
    [form addSubview:label];
    
    textField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.placeholder = NSLocalizedString(@"Profile.Hint.Email", nil);
    [form addSubview:textField];
    
    footer = [[MFFormFooter alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormFooter preferredHeight])];
    footer.lineBreakMode = NSLineBreakByWordWrapping;
    footer.text = NSLocalizedString(@"Profile.Hint.Footer", nil);
    [footer sizeToFit];
    [form addSubview:footer];
    
    form.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    form.tag = TAG_FORM;
    [view addSubview:form];
    
    view.backgroundColor = [UIColor themeBackgroundColor];
    self.view = view;
    
    [m_accessory deactivate];
    m_accessory = [[MFFormAccessory alloc] initWithContext:form];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [m_accessory activate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [m_accessory deactivate];
    [super viewDidDisappear:animated];
}

#pragma mark UITextFieldDelegate

#pragma mark UITextViewDelegate

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
