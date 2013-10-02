/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@protocol MFNewPostProgressViewDelegate;

@interface MFNewPostProgressView : UIView
{
    @private
    __unsafe_unretained id <MFNewPostProgressViewDelegate> m_delegate;
    NSArray *m_items;
    NSInteger m_selectedIndex;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, assign) id <MFNewPostProgressViewDelegate> delegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
