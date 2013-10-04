/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormAccessory.h"

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
        
        if(m_context) {
            [MFFormAccessory_Keyboard sharedInstance];
        }
    }
    
    return self;
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
