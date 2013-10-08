/* Copyright (c) 2013 Meep Factory OU */

#import "MFCondition.h"
#import "MFNewPostConditionTableViewCell.h"
#import "MFNewPostController+Condition.h"
#import "MFNewPostPageView.h"
#import "MFPageView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@interface MFNewPostController_Condition : MFNewPostPageView <UITableViewDataSource, UITableViewDelegate>
{
    @private
    NSArray *m_conditions;
    UITableView *m_tableView;
}

@end

#define CELL_IDENTIFIER @"cell"

@implementation MFNewPostController_Condition

#pragma mark MFNewPostPageView

- (id)initWithFrame:(CGRect)frame controller:(MFNewPostController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
        m_conditions = [MFCondition allConditions];
        m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        m_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        m_tableView.dataSource = self;
        m_tableView.delegate = self;
        m_tableView.rowHeight = [MFNewPostConditionTableViewCell preferredHeight];
        [self addSubview:m_tableView];
    }
    
    return self;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_conditions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFCondition *condition = [m_conditions objectAtIndex:indexPath.row];
    MFNewPostConditionTableViewCell *cell = (MFNewPostConditionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if(!cell) {
        cell = [[MFNewPostConditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.text = condition.title;
    cell.comments = condition.comments;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end

#pragma mark -

@implementation MFNewPostController(Condition)

- (MFNewPostPageView *)createConditionPageView
{
    return [[MFNewPostController_Condition alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
