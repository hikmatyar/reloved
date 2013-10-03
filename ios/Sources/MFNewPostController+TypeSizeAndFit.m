/* Copyright (c) 2013 Meep Factory OU */

#import "MFForm.h"
#import "MFFormButton.h"
#import "MFFormLabel.h"
#import "MFFormSeparator.h"
#import "MFFormTextView.h"
#import "MFNewPostController+TypeSizeAndFit.h"
#import "MFPageView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@interface MFNewPostController_TypeSizeAndFit : MFPageView <UITextViewDelegate>
{
    @private
    UITextView *m_fitDescriptionTextView;
    MFForm *m_form;
}

@end

@implementation MFNewPostController_TypeSizeAndFit

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        MFFormLabel *label;
        
        m_form = [[MFForm alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        m_form.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:m_form];
        
        label = [[MFFormLabel alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 20.0F)];
        label.text = @"Blah";
        [m_form addSubview:label];
        
        m_fitDescriptionTextView = [[MFFormTextView alloc] initWithFrame:CGRectMake(10.0F, 220.0F, 300.0F, 100.0F)];
        m_fitDescriptionTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        m_fitDescriptionTextView.backgroundColor = [UIColor redColor];
        m_fitDescriptionTextView.delegate = self;
        [m_form addSubview:m_fitDescriptionTextView];
    }
    
    return self;
}

#pragma mark MFPageView

- (void)pageWillDisappear
{
    [m_fitDescriptionTextView resignFirstResponder];
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [m_form scrollToView:textView animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
}

@end

#pragma mark -

@implementation MFNewPostController(TypeSizeAndFit)

- (MFPageView *)createTypeSizeAndFitPageView
{
    return [[MFNewPostController_TypeSizeAndFit alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
}

@end
