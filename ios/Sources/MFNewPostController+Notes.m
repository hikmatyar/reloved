/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrand.h"
#import "MFColor.h"
#import "MFType.h"
#import "MFDatabase+Brand.h"
#import "MFDatabase+Color.h"
#import "MFDatabase+Type.h"
#import "MFForm.h"
#import "MFFormAccessory.h"
#import "MFFormLabel.h"
#import "MFFormTextField.h"
#import "MFFormTextView.h"
#import "MFNewPostController+Notes.h"
#import "MFNewPostPageView.h"
#import "MFPost.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define SUBJECT_MIN 1
#define NOTES_MIN 1

@interface MFNewPostController_Notes : MFNewPostPageView <UITextFieldDelegate, UITextViewDelegate>
{
    @private
    MFFormAccessory *m_accessory;
    BOOL m_canContinue;
    MFFormTextField *m_subjectTextField;
    MFFormTextView *m_notesTextView;
    MFForm *m_form;
}

@end

@implementation MFNewPostController_Notes

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
        label.text = NSLocalizedString(@"NewPost.Label.Subject", nil);
        [m_form addSubview:label];
        
        m_subjectTextField = [[MFFormTextField alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormTextField preferredHeight])];
        m_subjectTextField.delegate = self;
        m_subjectTextField.returnKeyType = UIReturnKeyNext;
        m_subjectTextField.maxTextLength = 128;
        m_subjectTextField.placeholder = NSLocalizedString(@"NewPost.Hint.Subject", nil);
        [m_form addSubview:m_subjectTextField];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"NewPost.Label.Note", nil);
        [m_form addSubview:label];
        
        m_notesTextView = [[MFFormTextView alloc] initWithFrame:CGRectMake(10.0F, 220.0F, 300.0F, 100.0F)];
        m_notesTextView.delegate = self;
        m_notesTextView.maxTextLength = 400;
        m_notesTextView.placeholder = NSLocalizedString(@"NewPost.Hint.SellersNote", nil);
        [m_form addSubview:m_notesTextView];
        
        m_accessory = [[MFFormAccessory alloc] initWithContext:m_form];
    }
    
    return self;
}

- (BOOL)canContinue
{
    if(!m_canContinue) {
        m_canContinue = (m_subjectTextField.text.length >= SUBJECT_MIN && m_notesTextView.text.length >= NOTES_MIN) ? YES : NO;
    }
    
    return m_canContinue;
}

- (void)submitting
{
    MFMutablePost *post = m_controller.post;
    MFDatabase *database = [MFDatabase sharedDatabase];
    NSMutableSet *tags = [[NSMutableSet alloc] init];
    MFBrand *brand = [database brandForIdentifier:post.brandId];
    
    for(NSString *tag in post.notes.allTags) {
        [tags addObject:tag];
    }
    
    if(brand) {
        [tags addObject:brand.name.lowercaseString];
    }
    
    for(MFColor *color in [database colorsForIdentifiers:post.colorIds]) {
        [tags addObject:color.name.lowercaseString];
    }
    
    for(MFType *type in [database typesForIdentifiers:post.typeIds]) {
        [tags addObject:type.name.lowercaseString];
    }
    
    post.tags = tags.allObjects;
    
    [m_subjectTextField resignFirstResponder];
    [m_notesTextView resignFirstResponder];
}

- (void)saveState
{
    m_controller.post.title = m_subjectTextField.text;
    m_controller.post.notes = m_notesTextView.text;
}

#pragma mark MFPageView

- (void)pageWillAppear
{
    [m_accessory activate];
}

- (void)pageWillDisappear
{
    MFFormTextView *notesTextView = m_notesTextView;
    
    m_notesTextView = nil;
    [m_subjectTextField resignFirstResponder];
    [notesTextView resignFirstResponder];
    m_notesTextView = notesTextView;
    
    //[m_accessory deactivate];
    
    [super pageWillDisappear];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_notesTextView becomeFirstResponder];
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [m_controller invalidateNavigation];
    
    return ([textField isKindOfClass:[MFFormTextField class]]) ? [(MFFormTextField *)textField shouldChangeCharactersInRange:range replacementString:string] : YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [m_form scrollToView:textField animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [m_controller invalidateNavigation];
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [m_controller invalidateNavigation];
    
    return ([textView isKindOfClass:[MFFormTextView class]]) ? [(MFFormTextView *)textView shouldChangeCharactersInRange:range replacementString:text] : YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [m_form scrollToView:textView animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [m_controller invalidateNavigation];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [m_controller invalidateNavigation];
}

@end

#pragma mark -

@implementation MFNewPostController(Notes)

- (MFNewPostPageView *)createNotesPageView
{
    return [[MFNewPostController_Notes alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
