/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFCondition;

@interface MFConditionController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    @private
    MFCondition *m_condition;
}

- (id)initWithCondition:(MFCondition *)condition;

@property (nonatomic, retain, readonly) MFCondition *condition;

@end
