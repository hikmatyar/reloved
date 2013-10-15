/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase+Size.h"
#import "MFDatabase+Type.h"
#import "MFForm.h"
#import "MFFormAccessory.h"
#import "MFFormButton.h"
#import "MFFormLabel.h"
#import "MFFormSeparator.h"
#import "MFFormTextView.h"
#import "MFNewPostController+TypeSizeAndFit.h"
#import "MFNewPostPageView.h"
#import "MFOptionPickerController.h"
#import "MFOptionPickerControllerDelegate.h"
#import "MFPost.h"
#import "MFSize.h"
#import "MFType.h"
#import "MFWebFeed.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+Additions.h"

@interface MFNewPostController_TypeSizeAndFit : MFNewPostPageView <MFOptionPickerControllerDelegate, UITextViewDelegate>
{
    @private
    MFFormAccessory *m_accessory;
    MFFormButton *m_typeButton;
    MFFormButton *m_sizeButton;
    BOOL m_canContinue;
    MFFormTextView *m_fitDescriptionTextView;
    MFForm *m_form;
}

- (id)initWithFrame:(CGRect)frame controller:(MFNewPostController *)controller;

@end

@implementation MFNewPostController_TypeSizeAndFit

- (IBAction)size:(id)sender
{
    NSArray *sizes = [MFDatabase sharedDatabase].sizes;
    
    if(sizes.count > 0) {
        MFOptionPickerController *controller = [[MFOptionPickerController alloc] init];
        
        controller.items = [sizes sortedArrayUsingSelector:@selector(compare:)];
        controller.delegate = self;
        controller.title = NSLocalizedString(@"NewPost.Title.Size", nil);
        [m_controller presentNavigableViewController:controller animated:YES completion:NULL];
    } else {
        [[MFWebFeed sharedFeed] loadForward];
    }
}

- (IBAction)type:(id)sender
{
    NSArray *types = [MFDatabase sharedDatabase].types;
    
    if(types.count > 0) {
        MFOptionPickerController *controller = [[MFOptionPickerController alloc] init];
        
        controller.items = [types sortedArrayUsingSelector:@selector(compare:)];
        controller.allowsMultipleSelection = YES;
        controller.delegate = self;
        controller.title = NSLocalizedString(@"NewPost.Title.Type", nil);
        [m_controller presentNavigableViewController:controller animated:YES completion:NULL];
    } else {
        [[MFWebFeed sharedFeed] loadForward];
    }
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
        label.text = NSLocalizedString(@"NewPost.Label.Type", nil);
        [m_form addSubview:label];
        
        m_typeButton = [[MFFormButton alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormButton preferredHeight])];
        m_typeButton.placeholder = NSLocalizedString(@"NewPost.Hint.Type", nil);
        [m_typeButton addTarget:self action:@selector(type:) forControlEvents:UIControlEventTouchUpInside];
        [m_typeButton setTitle:nil forState:UIControlStateNormal];
        [m_form addSubview:m_typeButton];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"NewPost.Label.Size", nil);
        [m_form addSubview:label];
        
        m_sizeButton = [[MFFormButton alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormButton preferredHeight])];
        m_sizeButton.placeholder = NSLocalizedString(@"NewPost.Hint.Size", nil);
        [m_sizeButton addTarget:self action:@selector(size:) forControlEvents:UIControlEventTouchUpInside];
        [m_sizeButton setTitle:nil forState:UIControlStateNormal];
        [m_form addSubview:m_sizeButton];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"NewPost.Label.Fit", nil);
        [m_form addSubview:label];
        
        m_fitDescriptionTextView = [[MFFormTextView alloc] initWithFrame:CGRectMake(10.0F, 220.0F, 300.0F, 100.0F)];
        m_fitDescriptionTextView.delegate = self;
        m_fitDescriptionTextView.placeholder = NSLocalizedString(@"NewPost.Hint.Fit", nil);
        [m_form addSubview:m_fitDescriptionTextView];
        
        m_accessory = [[MFFormAccessory alloc] initWithContext:m_form];
    }
    
    return self;
}


- (BOOL)canContinue
{
    if(!m_canContinue) {
        m_canContinue = YES;//(m_fitDescriptionTextView.text.length > 0 && !m_typeButton.empty && !m_sizeButton.empty) ? YES : NO;
    }
    
    return m_canContinue;
}

- (void)saveState
{
    m_controller.post.fit = m_fitDescriptionTextView.text;
}

#pragma mark MFOptionPickerControllerDelegate

- (void)optionPickerControllerDidComplete:(MFOptionPickerController *)controller
{
    id selection = controller.selectedItem;
    
    if(selection) {
        NSMutableArray *typeIdentifiers = nil;
        NSMutableString *typeTitle = nil;
        
        if([selection isKindOfClass:[MFType class]]) {
            MFType *type = (MFType *)selection;
            
            if(typeTitle) {
                [typeTitle appendFormat:@", %@", type.name];
            } else {
                typeTitle = [NSMutableString stringWithString:type.name];
            }
            
            if(!typeIdentifiers) {
                typeIdentifiers = [NSMutableArray array];
            }
            
            [typeIdentifiers addObject:type.identifier];
        } else if([selection isKindOfClass:[MFSize class]]) {
            MFSize *size = (MFSize *)selection;
            
            [m_sizeButton setTitle:size.name forState:UIControlStateNormal];
            m_controller.post.sizeId = size.identifier;
        }
        
        if(typeTitle) {
            [m_sizeButton setTitle:typeTitle forState:UIControlStateNormal];
        }
        
        if(typeIdentifiers) {
            m_controller.post.typeIds = typeIdentifiers;
        }
    }
    
    [m_controller invalidateNavigation];
}

#pragma mark MFPageView

- (void)pageWillAppear
{
    [m_accessory activate];
}

- (void)pageWillDisappear
{
    [m_fitDescriptionTextView resignFirstResponder];
    //[m_accessory deactivate];
    [super pageWillDisappear];
}

#pragma mark UITextViewDelegate

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

@implementation MFNewPostController(TypeSizeAndFit)

- (MFNewPostPageView *)createTypeSizeAndFitPageView
{
    return [[MFNewPostController_TypeSizeAndFit alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
