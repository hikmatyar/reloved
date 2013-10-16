/* Copyright (c) 2013 Meep Factory OU */

#import "MFTableView.h"

@class MFPost, MFPostTableViewCell;
@protocol MFPostHeaderViewDelegate;

@interface MFPostHeaderView : UIView <MFTableView>
{
    @private
    __unsafe_unretained id <MFPostHeaderViewDelegate> m_delegate;
    MFPostTableViewCell *m_cell;
    NSMutableDictionary *m_images;
    NSMutableDictionary *m_resources;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, assign) id <MFPostHeaderViewDelegate> delegate;
@property (nonatomic, retain) MFPost *post;

@end
