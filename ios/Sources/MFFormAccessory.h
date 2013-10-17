/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@protocol MFFormAccessoryDelegate;

@interface MFFormAccessory : NSObject
{
    @private
    UIScrollView *m_context;
    __unsafe_unretained id <MFFormAccessoryDelegate> m_delegate;
    NSArray *m_fields;
    UIToolbar *m_toolbar;
    UISegmentedControl *m_segmentedControl;
    UIBarButtonItem *m_doneButton;
    UIBarButtonItem *m_segmentedControlItem;
}

+ (BOOL)isVisible;

- (id)initWithContext:(UIScrollView *)context;

@property (nonatomic, assign) id <MFFormAccessoryDelegate> delegate;
@property (nonatomic, retain) NSArray *fields;
@property (nonatomic, retain) UIResponder *firstResponder;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, assign, getter = isDoneEnabled) BOOL doneEnabled;

- (void)invalidate;
- (void)activate;
- (void)deactivate;

@end
