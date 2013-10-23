/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrowseFilterController.h"
#import "MFBrowseFilterControllerDelegate.h"
#import "MFColor.h"
#import "MFDatabase+Color.h"
#import "MFDatabase+Size.h"
#import "MFDatabase+Type.h"
#import "MFPreferences.h"
#import "MFSectionHeaderView.h"
#import "MFSize.h"
#import "MFType.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define CELL_IDENTIFIER1 @"cell1"
#define CELL_IDENTIFIER2 @"cell2"

#define TAG_CATEGORY_PICKER 1000
#define NO_COLOR 1

@implementation MFBrowseFilterController

- (UITableView *)tableView
{
    return (UITableView *)self.view;
}

- (UISegmentedControl *)categoryPicker
{
    return (UISegmentedControl *)[self.tableView.tableHeaderView viewWithTag:TAG_CATEGORY_PICKER];
}

- (id)initWithCategory:(MFBrowseFilterControllerCategory)category
{
    self = [super init];
    
    if(self) {
        MFPreferences *preferences = [MFPreferences sharedPreferences];
        NSArray *excludeColors = preferences.excludeColors;
        NSArray *excludeSizes = preferences.excludeSizes;
        NSArray *excludeTypes = preferences.excludeTypes;
        MFDatabase *database = [MFDatabase sharedDatabase];
        NSInteger colorIndex = 0, sizeIndex = 0, typeIndex = 0;
        
        m_excludeColors = [[NSMutableSet alloc] init];
        m_excludeSizes = [[NSMutableSet alloc] init];
        m_excludeTypes = [[NSMutableSet alloc] init];
        m_category = category;
        
        for(MFColor *color in database.colors) {
            if([excludeColors containsObject:color.identifier]) {
                [m_excludeColors addObject:[NSNumber numberWithInteger:colorIndex]];
            }
            
            colorIndex++;
        }
        
        for(MFSize *size in database.sizes) {
            if([excludeSizes containsObject:size.identifier]) {
                [m_excludeSizes addObject:[NSNumber numberWithInteger:sizeIndex]];
            }
            
            sizeIndex++;
        }
        
        for(MFType *type in database.types) {
            if([excludeTypes containsObject:type.identifier]) {
                [m_excludeTypes addObject:[NSNumber numberWithInteger:typeIndex]];
            }
            
            typeIndex++;
        }
        
        self.navigationItem.title = NSLocalizedString(@"Browse.Title", nil);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Browse.Action.SelectAll", nil) style:UIBarButtonItemStylePlain target:self action:@selector(selectAll:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Browse.Action.Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    }
    
    return self;
}

- (id)initWithDelegate:(id <MFBrowseFilterControllerDelegate>)delegate
{
    self = [self init];
    
    if(self) {
        m_delegate = delegate;
    }
    
    return self;
}

@synthesize delegate = m_delegate;

- (IBAction)category:(id)sender
{
    switch(self.categoryPicker.selectedSegmentIndex) {
        case 0:
            m_category = kMFBrowseFilterControllerCategorySize;
            break;
        case 1:
            m_category = kMFBrowseFilterControllerCategoryType;
            break;
        case 2:
            m_category = kMFBrowseFilterControllerCategoryColor;
            break;
    }
    
    [self.tableView reloadData];
}

- (IBAction)selectAll:(id)sender
{
    switch(m_category) {
        case kMFBrowseFilterControllerCategoryColor:
            [m_excludeColors removeAllObjects];
            [self.tableView reloadData];
            break;
        case kMFBrowseFilterControllerCategorySize:
            [m_excludeSizes removeAllObjects];
            [self.tableView reloadData];
            break;
        case kMFBrowseFilterControllerCategoryType:
            [m_excludeTypes removeAllObjects];
            [self.tableView reloadData];
            break;
    }
}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)dataDidChange:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(m_category) {
        case kMFBrowseFilterControllerCategoryColor:
            return [MFDatabase sharedDatabase].colors.count;
        case kMFBrowseFilterControllerCategorySize:
            return [MFDatabase sharedDatabase].sizes.count;
        case kMFBrowseFilterControllerCategoryType:
            return [MFDatabase sharedDatabase].types.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER2];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER2];
        cell.backgroundColor = [UIColor themeBackgroundColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indentationWidth = 12.0F;
        cell.indentationLevel = 1;
        cell.textLabel.font = [UIFont themeFontOfSize:14.0F];
        cell.textLabel.textColor = [UIColor themeTextColor];
    }
    
    switch(m_category) {
        case kMFBrowseFilterControllerCategoryColor: {
            MFColor *color = [[MFDatabase sharedDatabase].colors objectAtIndex:indexPath.row];
            
            cell.textLabel.text = color.name;
            cell.accessoryType = ([m_excludeColors containsObject:[NSNumber numberWithInteger:indexPath.row]]) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
            } break;
        case kMFBrowseFilterControllerCategorySize: {
            MFSize *size = [[MFDatabase sharedDatabase].sizes objectAtIndex:indexPath.row];
            
            cell.textLabel.text = size.name;
            cell.accessoryType = ([m_excludeSizes containsObject:[NSNumber numberWithInteger:indexPath.row]]) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
            } break;
        case kMFBrowseFilterControllerCategoryType: {
            MFType *type = [[MFDatabase sharedDatabase].types objectAtIndex:indexPath.row];
            
            cell.textLabel.text = type.name;
            cell.accessoryType = ([m_excludeTypes containsObject:[NSNumber numberWithInteger:indexPath.row]]) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
            } break;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [MFSectionHeaderView preferredHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    
    switch(m_category) {
        case kMFBrowseFilterControllerCategoryColor:
            title = NSLocalizedString(@"Browse.Label.Color", nil);
            break;
        case kMFBrowseFilterControllerCategorySize:
            title = NSLocalizedString(@"Browse.Label.Size", nil);
            break;
        case kMFBrowseFilterControllerCategoryType:
            title = NSLocalizedString(@"Browse.Label.Type", nil);
            break;
    }
    
    return (title) ? [[MFSectionHeaderView alloc] initWithTitle:title] : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSNumber *index = [NSNumber numberWithInteger:indexPath.row];
    NSMutableSet *excludeSet = nil;
    BOOL selected = NO;
    
    switch(m_category) {
        case kMFBrowseFilterControllerCategoryColor: {
            excludeSet = m_excludeColors;
            } break;
        case kMFBrowseFilterControllerCategorySize: {
            excludeSet = m_excludeSizes;
            } break;
        case kMFBrowseFilterControllerCategoryType: {
            excludeSet = m_excludeTypes;
            } break;
    }
    
    selected = [excludeSet containsObject:index];
    
    if(selected) {
        [excludeSet removeObject:index];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        [excludeSet addObject:index];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark UIViewController

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) style:UITableViewStylePlain];
    UISegmentedControl *categoryPicker = [[UISegmentedControl alloc] initWithItems:
        [NSArray arrayWithObjects:
            NSLocalizedString(@"Browse.Action.Size", nil),
            NSLocalizedString(@"Browse.Action.Type", nil),
#if !NO_COLOR
            NSLocalizedString(@"Browse.Action.Color", nil),
#endif
            nil]];
    UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 42.0F)];
    
#if NO_COLOR
    [categoryPicker setWidth:100.0F forSegmentAtIndex:0];
    [categoryPicker setWidth:100.0F forSegmentAtIndex:1];
#else
    [categoryPicker setWidth:70.0F forSegmentAtIndex:0];
    [categoryPicker setWidth:70.0F forSegmentAtIndex:1];
    [categoryPicker setWidth:70.0F forSegmentAtIndex:2];
#endif
    
    categoryPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    categoryPicker.center = CGPointMake(160.0F, 20.0F);
    categoryPicker.tag = TAG_CATEGORY_PICKER;
    [categoryPicker addTarget:self action:@selector(category:) forControlEvents:UIControlEventValueChanged];
    [categoryView addSubview:categoryPicker];
    
    switch(m_category) {
        case kMFBrowseFilterControllerCategorySize:
            categoryPicker.selectedSegmentIndex = 0;
            break;
        case kMFBrowseFilterControllerCategoryType:
            categoryPicker.selectedSegmentIndex = 1;
            break;
        case kMFBrowseFilterControllerCategoryColor:
            categoryPicker.selectedSegmentIndex = 2;
            break;
    }
    
    tableView.tableHeaderView = categoryView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 46.0F;
    tableView.backgroundColor = [UIColor themeBackgroundColor];
    tableView.separatorColor = [UIColor themeSeparatorColor];
    tableView.allowsMultipleSelection = YES;
    
    self.view = tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [super viewWillAppear:animated];
    [center addObserver:self selector:@selector(dataDidChange:) name:MFDatabaseDidChangeColorsNotification object:nil];
    [center addObserver:self selector:@selector(dataDidChange:) name:MFDatabaseDidChangeSizesNotification object:nil];
    [center addObserver:self selector:@selector(dataDidChange:) name:MFDatabaseDidChangeTypesNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    MFPreferences *preferences = [MFPreferences sharedPreferences];
    NSMutableArray *excludeColors = [NSMutableArray array];
    NSMutableArray *excludeSizes = [NSMutableArray array];
    NSMutableArray *excludeTypes = [NSMutableArray array];
    MFDatabase *database = [MFDatabase sharedDatabase];
    NSArray *colors = database.colors;
    NSArray *sizes = database.sizes;
    NSArray *types = database.types;
    
    for(NSNumber *row in m_excludeColors) {
        NSInteger index = row.integerValue;
        
        if(index >= 0 && index < colors.count) {
            MFColor *color = [colors objectAtIndex:index];
            
            [excludeColors addObject:color.identifier];
        }
    }
    
    for(NSNumber *row in m_excludeSizes) {
        NSInteger index = row.integerValue;
        
        if(index >= 0 && index < sizes.count) {
            MFSize *size = [sizes objectAtIndex:index];
            
            [excludeSizes addObject:size.identifier];
        }
    }
    
    for(NSNumber *row in m_excludeTypes) {
        NSInteger index = row.integerValue;
        
        if(index >= 0 && index < types.count) {
            MFType *type = [types objectAtIndex:index];
            
            [excludeTypes addObject:type.identifier];
        }
    }
    
    [excludeColors sortedArrayUsingSelector:@selector(compare:)];
    [excludeSizes sortedArrayUsingSelector:@selector(compare:)];
    [excludeTypes sortedArrayUsingSelector:@selector(compare:)];
    
    preferences.category = m_category;
    preferences.excludeColors = (excludeColors.count > 0) ? excludeColors : nil;
    preferences.excludeSizes = (excludeSizes.count > 0) ? excludeSizes : nil;
    preferences.excludeTypes = (excludeTypes.count > 0) ? excludeTypes : nil;
    
    [center removeObserver:self name:MFDatabaseDidChangeColorsNotification object:nil];
    [center removeObserver:self name:MFDatabaseDidChangeSizesNotification object:nil];
    [center removeObserver:self name:MFDatabaseDidChangeTypesNotification object:nil];
    
    if([m_delegate respondsToSelector:@selector(filterControllerDidClose:)]) {
        [m_delegate filterControllerDidClose:self];
    }
    
    [super viewWillDisappear:animated];
}

#pragma mark NSObject

- (id)init
{
    NSInteger category = [MFPreferences sharedPreferences].category;
    
    return [self initWithCategory:(category >= kMFBrowseFilterControllerCategoryMin && category <= kMFBrowseFilterControllerCategoryMax) ? (MFBrowseFilterControllerCategory)category : kMFBrowseFilterControllerCategorySize];
}

@end
