/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrowseFilterController.h"
#import "MFDatabase+Size.h"
#import "MFDatabase+Type.h"
#import "MFPreferences.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define CELL_IDENTIFIER @"cell"

#define TAG_CATEGORY_PICKER 1000

@implementation MFBrowseFilterController

- (id)initWithCategory:(MFBrowseFilterControllerCategory)category
{
    self = [super init];
    
    if(self) {
        m_category = category;
        
        self.navigationItem.title = NSLocalizedString(@"Browse.Title", nil);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Browse.Action.Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    }
    
    return self;
}

- (IBAction)category:(id)sender
{

}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark UIView

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) style:UITableViewStylePlain];
    UISegmentedControl *categoryPicker = [[UISegmentedControl alloc] initWithItems:
        [NSArray arrayWithObjects:
            NSLocalizedString(@"Browse.Action.Size", nil),
            NSLocalizedString(@"Browse.Action.Type", nil), nil]];
    UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 62.0F)];
    
    [categoryPicker setWidth:100.0F forSegmentAtIndex:0];
    [categoryPicker setWidth:100.0F forSegmentAtIndex:1];
    categoryPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    categoryPicker.center = CGPointMake(160.0F, 20.0F);
    categoryPicker.tag = TAG_CATEGORY_PICKER;
    [categoryPicker addTarget:self action:@selector(category:) forControlEvents:UIControlEventValueChanged];
    [categoryView addSubview:categoryPicker];
    
    tableView.tableHeaderView = categoryView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 46.0F;
    tableView.backgroundColor = [UIColor themeBackgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view = tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MFPreferences sharedPreferences].category = m_category;
    [super viewWillDisappear:animated];
}

#pragma mark NSObject

- (id)init
{
    NSInteger category = [MFPreferences sharedPreferences].category;
    
    return [self initWithCategory:(category >= kMFBrowseFilterControllerCategoryMin && category <= kMFBrowseFilterControllerCategoryMax) ? (MFBrowseFilterControllerCategory)category : kMFBrowseFilterControllerCategorySize];
}

@end
