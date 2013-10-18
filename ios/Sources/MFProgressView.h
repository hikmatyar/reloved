/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@protocol MFProgressViewDelegate;

typedef enum _MFProgressViewStyle {
    kMFProgressViewStyleDefault = 0,
    kMFProgressViewStyleCheckout
} MFProgressViewStyle;

@interface MFProgressView : UIView
{
    @private
    __unsafe_unretained id <MFProgressViewDelegate> m_delegate;
    NSArray *m_items;
    NSInteger m_selectedIndex;
    MFProgressViewStyle m_style;
}

+ (CGFloat)preferredHeight;

- (id)initWithFrame:(CGRect)frame style:(MFProgressViewStyle)style;

@property (nonatomic, assign) id <MFProgressViewDelegate> delegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
