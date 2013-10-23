/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrand.h"
#import "MFColor.h"
#import "MFDatabase+Brand.h"
#import "MFDatabase+Color.h"
#import "MFForm.h"
#import "MFFormAccessory.h"
#import "MFFormButton.h"
#import "MFFormLabel.h"
#import "MFFormTextField.h"
#import "MFFormTextView.h"
#import "MFNewPostController+Details.h"
#import "MFNewPostPageView.h"
#import "MFOptionPickerController.h"
#import "MFOptionPickerControllerDelegate.h"
#import "MFPost.h"
#import "MFWebFeed.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+Additions.h"

@interface MFNewPostController_Details : MFNewPostPageView <MFOptionPickerControllerDelegate, UITextViewDelegate>
{
    @private
    MFFormAccessory *m_accessory;
    BOOL m_canContinue;
    MFFormButton *m_brandButton;
    MFFormButton *m_colorsButton;
    MFFormTextView *m_materialsTextView;
    MFForm *m_form;
}

@end

@implementation MFNewPostController_Details

- (IBAction)brand:(id)sender
{
    NSArray *brands = [MFDatabase sharedDatabase].brands;
    
    if(brands.count > 0) {
        MFOptionPickerController *controller = [[MFOptionPickerController alloc] init];
        
        controller.items = [brands sortedArrayUsingSelector:@selector(compare:)];
        controller.delegate = self;
        controller.title = NSLocalizedString(@"NewPost.Title.Brand", nil);
        [m_controller presentNavigableViewController:controller animated:YES completion:NULL];
    } else {
        [[MFWebFeed sharedFeed] loadForward];
    }
}

- (IBAction)colors:(id)sender
{
    NSArray *colors = [MFDatabase sharedDatabase].colors;
    
    if(colors.count > 0) {
        MFOptionPickerController *controller = [[MFOptionPickerController alloc] init];
        
        controller.allowsMultipleSelection = YES;
        controller.maximumSelectedItems = 5;
        controller.items = [colors sortedArrayUsingSelector:@selector(compare:)];
        controller.delegate = self;
        controller.title = NSLocalizedString(@"NewPost.Title.Colors", nil);
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
        label.text = NSLocalizedString(@"NewPost.Label.Materials", nil);
        [m_form addSubview:label];
        
        m_materialsTextView = [[MFFormTextView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 1.5F * [MFFormTextField preferredHeight])];
        m_materialsTextView.delegate = self;
        //m_materialsTextView.returnKeyType = UIReturnKeyDone;
        m_materialsTextView.placeholder = NSLocalizedString(@"NewPost.Hint.Materials", nil);
        m_materialsTextView.maxTextLength = 200;
        [m_form addSubview:m_materialsTextView];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"NewPost.Label.Colors", nil);
        [m_form addSubview:label];
        
        m_colorsButton = [[MFFormButton alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormButton preferredHeight])];
        m_colorsButton.placeholder = NSLocalizedString(@"NewPost.Hint.Colors", nil);
        [m_colorsButton addTarget:self action:@selector(colors:) forControlEvents:UIControlEventTouchUpInside];
        [m_colorsButton setTitle:nil forState:UIControlStateNormal];
        [m_form addSubview:m_colorsButton];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormLabel preferredHeight])];
        label.text = NSLocalizedString(@"NewPost.Label.Brand", nil);
        [m_form addSubview:label];
        
        m_brandButton = [[MFFormButton alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, [MFFormButton preferredHeight])];
        m_brandButton.placeholder = NSLocalizedString(@"NewPost.Hint.Brand", nil);
        [m_brandButton addTarget:self action:@selector(brand:) forControlEvents:UIControlEventTouchUpInside];
        [m_brandButton setTitle:nil forState:UIControlStateNormal];
        [m_form addSubview:m_brandButton];
        
        m_accessory = [[MFFormAccessory alloc] initWithContext:m_form];
    }
    
    return self;
}

- (BOOL)canContinue
{
    if(!m_canContinue) {
        m_canContinue = (m_materialsTextView.text.length > 0 && !m_brandButton.empty && !m_colorsButton.empty) ? YES : NO;
    }
    
    return m_canContinue;
}

- (void)saveState
{
    m_controller.post.materials = m_materialsTextView.text;
}

#pragma mark MFOptionPickerControllerDelegate

- (void)optionPickerControllerDidClose:(MFOptionPickerController *)controller
{
    NSMutableArray *colorIdentifiers = nil;
    NSMutableString *colorTitle = nil;
    
    for(id selection in controller.selectedItems) {
        if([selection isKindOfClass:[MFBrand class]]) {
            MFBrand *brand = (MFBrand *)selection;
            
            [m_brandButton setTitle:brand.name forState:UIControlStateNormal];
            m_controller.post.brandId = brand.identifier;
        } else if([selection isKindOfClass:[MFColor class]]) {
            MFColor *color = (MFColor *)selection;
            
            if(colorTitle) {
                [colorTitle appendFormat:@", %@", color.name];
            } else {
                colorTitle = [NSMutableString stringWithString:color.name];
            }
            
            if(!colorIdentifiers) {
                colorIdentifiers = [NSMutableArray array];
            }
            
            [colorIdentifiers addObject:color.identifier];
        }
    }
    
    if(colorTitle) {
        [m_colorsButton setTitle:colorTitle forState:UIControlStateNormal];
    }
    
    if(colorIdentifiers) {
        m_controller.post.colorIds = colorIdentifiers;
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
    [m_materialsTextView resignFirstResponder];
    //[m_accessory deactivate];
    [super pageWillDisappear];
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
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

@implementation MFNewPostController(Details)

- (MFNewPostPageView *)createDetailsPageView
{
    return [[MFNewPostController_Details alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
