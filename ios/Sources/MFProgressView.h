/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@protocol MFProgressViewDelegate;

@interface MFProgressView : UIView
{
    @private
    __unsafe_unretained id <MFProgressViewDelegate> m_delegate;
    NSArray *m_items;
    NSInteger m_selectedIndex;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, assign) id <MFProgressViewDelegate> delegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
