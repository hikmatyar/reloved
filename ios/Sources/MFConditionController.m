/* Copyright (c) 2013 Meep Factory OU */

#import "MFCondition.h"
#import "MFConditionController.h"
#import "MFConditionTableViewCell.h"

#define CELL_IDENTIFIER @"cell"

@implementation MFConditionController

- (id)initWithCondition:(MFCondition *)condition
{
    self = [super init];
    
    if(self) {
        m_condition = condition;
        self.title = NSLocalizedString(@"Condition.Title", nil);
    }
    
    return self;
}

@synthesize condition = m_condition;

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFConditionTableViewCell *cell = (MFConditionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if(!cell) {
        cell = [[MFConditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        cell.userInteractionEnabled = NO;
    }
    
    cell.text = m_condition.title;
    cell.comments = m_condition.comments;
    cell.selected = NO;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark UIView

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
    tableView.allowsSelection = NO;
    tableView.allowsMultipleSelection = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = [MFConditionTableViewCell preferredHeight];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.bounces = NO;
    
    if([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        tableView.separatorInset = UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F);
    }
    
    self.view = tableView;
}

@end
