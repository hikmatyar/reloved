/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormAccessory.h"
#import "MFFormAccessoryDelegate.h"

#define ITEM_PREV 0
#define ITEM_NEXT 1

@interface MFFormAccessory_Keyboard : NSObject
{
    @private
    BOOL m_visible;
}

+ (MFFormAccessory_Keyboard *)sharedInstance;

@property (nonatomic, assign, readonly) BOOL visible;

@end

@implementation MFFormAccessory_Keyboard

+ (MFFormAccessory_Keyboard *)sharedInstance
{
    __strong static MFFormAccessory_Keyboard *sharedInstance = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

@synthesize visible = m_visible;

- (void)keyboardDidShow:(NSNotification *)notification
{
    m_visible = YES;
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    m_visible = NO;
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        m_visible = NO;
        
        [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#pragma mark -

@implementation MFFormAccessory

+ (BOOL)isVisible
{
    return [MFFormAccessory_Keyboard sharedInstance].visible;
}

- (id)initWithContext:(UIScrollView *)context
{
    self = [super init];
    
    if(self) {
        m_context = context;
        m_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 44.0F)];
        m_toolbar.barStyle = UIBarStyleBlackTranslucent;
        
        m_segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
                                                                        NSLocalizedString(@"Form.Action.Prev", nil),
                                                                        NSLocalizedString(@"Form.Action.Next", nil), nil ]];
        [m_segmentedControl addTarget:self action:@selector(prevOrNext:) forControlEvents:UIControlEventValueChanged];
        m_segmentedControl.momentary = YES;
        m_segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        [m_segmentedControl setEnabled:NO forSegmentAtIndex:ITEM_PREV];
        [m_segmentedControl setEnabled:NO forSegmentAtIndex:ITEM_NEXT];
        m_segmentedControlItem = [[UIBarButtonItem alloc] initWithCustomView:m_segmentedControl];
        
        m_doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Form.Action.Done", nil)
                                                        style:UIBarButtonItemStyleDone
                                                       target:self
                                                       action:@selector(done:)];
        
        m_toolbar.items = [NSArray arrayWithObjects:
                           m_segmentedControlItem,
                           [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           m_doneButton, nil];
        
        if(m_context) {
            [MFFormAccessory_Keyboard sharedInstance];
        }
    }
    
    return self;
}

- (IBAction)prev:(id)sender
{
    UIResponder *firstResponder = self.firstResponder;
    NSInteger index;
    
    if(firstResponder && (index = [m_fields indexOfObject:firstResponder]) != NSNotFound && index > 0) {
        self.firstResponder = [m_fields objectAtIndex:index - 1];
        
        if([m_delegate respondsToSelector:@selector(accessoryDidTapPrev:)]) {
            [m_delegate accessoryDidTapPrev:self];
        }
    }
}

- (IBAction)next:(id)sender
{
    UIResponder *firstResponder = self.firstResponder;
    NSInteger index;
    
    if(firstResponder && (index = [m_fields indexOfObject:firstResponder]) != NSNotFound && index + 1 < m_fields.count) {
        self.firstResponder = [m_fields objectAtIndex:index + 1];
        
        if([m_delegate respondsToSelector:@selector(accessoryDidTapNext:)]) {
            [m_delegate accessoryDidTapNext:self];
        }
    }
}

- (IBAction)done:(id)sender
{
    if([m_delegate respondsToSelector:@selector(accessoryDidTapDone:)]) {
        [m_delegate accessoryDidTapDone:self];
    } else {
        [self.firstResponder resignFirstResponder];
    }
}

- (IBAction)prevOrNext:(id)sender
{
    switch(m_segmentedControl.selectedSegmentIndex) {
        case ITEM_PREV:
            [self prev:sender];
            break;
        case ITEM_NEXT:
            [self next:sender];
            break;
    }
}

@dynamic fields;

- (NSArray *)fields
{
    return m_fields;
}

- (void)setFields:(NSArray *)fields
{
    if(m_fields != fields) {
        for(UIView *field in m_fields) {
            if([field respondsToSelector:@selector(setInputAccessoryView:)]) {
                [field performSelector:@selector(setInputAccessoryView:) withObject:nil];
            }
        }
        
        m_fields = fields;
        
        for(UIView *field in m_fields) {
            if([field respondsToSelector:@selector(setInputAccessoryView:)]) {
                [field performSelector:@selector(setInputAccessoryView:) withObject:m_toolbar];
            }
        }
        
        [self invalidate];
    }
}

@synthesize delegate = m_delegate;
@synthesize toolbar = m_toolbar;

@dynamic firstResponder;

- (UIResponder *)firstResponder
{
    for(UIResponder *field in m_fields) {
        if([field isFirstResponder]) {
            return field;
        }
    }
    
    return nil;
}

- (void)setFirstResponder:(UIResponder *)firstResponder
{
    if(firstResponder && [m_fields containsObject:firstResponder]) {
        if(!firstResponder.isFirstResponder) {
            [firstResponder becomeFirstResponder];
        }
        
        [self invalidate];
    }    
}

@dynamic doneEnabled;

- (BOOL)isDoneEnabled
{
    return m_doneButton.enabled;
}

- (void)setDoneEnabled:(BOOL)doneEnabled
{
    m_doneButton.enabled = doneEnabled;
}

- (void)invalidate
{
    UIResponder *firstResponder = self.firstResponder;
    NSInteger index;
    
    if(firstResponder && (index = [m_fields indexOfObject:firstResponder]) != NSNotFound) {
        [m_segmentedControl setEnabled:(index > 0) ? YES : NO forSegmentAtIndex:ITEM_PREV];
        [m_segmentedControl setEnabled:(index + 1 < m_fields.count) ? YES : NO forSegmentAtIndex:ITEM_NEXT];
    }
}

- (void)activate
{
    if(m_context) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)deactivate
{
    if(m_context) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect to = ((NSValue *)[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]).CGRectValue;
    UIViewAnimationCurve curve = ((NSNumber *)[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]).integerValue;
    CGFloat duration = ((NSNumber *)[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]).doubleValue;
    CGRect frame = m_context.superview.bounds;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    
    m_context.frame = CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height - to.size.height);
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIViewAnimationCurve curve = ((NSNumber *)[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]).integerValue;
    CGFloat duration = ((NSNumber *)[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]).doubleValue;
    CGRect frame = m_context.superview.bounds;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    
    m_context.frame = frame;
    
    [UIView commitAnimations];
}

#pragma mark NSObject

- (id)init
{
    return [self initWithContext:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
