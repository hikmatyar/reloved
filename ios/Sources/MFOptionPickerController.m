/* Copyright (c) 2013 Meep Factory OU */

#import "MFOptionPickerController.h"
#import "MFOptionPickerControllerDelegate.h"
#import "MFSectionHeaderView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

static inline NSString *MFOptionPickerControllerGetItemTitle(id item) {
    if([item respondsToSelector:@selector(title)]) {
        return [item title];
    }
    
    if([item respondsToSelector:@selector(name)]) {
        return [item name];
    }
    
    return [item description];
}

#pragma mark -

#define CELL_IDENTIFIER @"cell"

@implementation MFOptionPickerController

- (UITableView *)tableView
{
    return (UITableView *)self.view;
}

@synthesize allowsEmptySelection = m_allowsEmptySelection;

@dynamic allowsMultipleSelection;

- (BOOL)allowsMultipleSelection
{
    return self.tableView.allowsMultipleSelection;
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    self.tableView.allowsMultipleSelection = allowsMultipleSelection;
}

@dynamic allowsSearch;

- (BOOL)allowsSearch
{
    return m_allowsSearch;
}

- (void)setAllowsSearch:(BOOL)allowsSearch
{
    
    if(m_allowsSearch != allowsSearch) {
        UITableView *tableView = self.tableView;
        
        m_allowsSearch = allowsSearch;
        
        if(allowsSearch) {
            // This is buggy in iOS 7.0. https://devforums.apple.com/message/882278#882278
            //UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 56.0F)];
            //
            //searchBar.delegate = self;
            //tableView.tableHeaderView = searchBar;
        } else {
            tableView.tableHeaderView = nil;
        }
    }
}

@synthesize delegate = m_delegate;

@dynamic selectedItem;

- (id)selectedItem
{
    return self.selectedItems.anyObject;
}

- (void)setSelectedItem:(id)selectedItem
{
    self.selectedItems = (selectedItem) ? [NSSet setWithObject:selectedItem] : nil;
}

- (NSSet *)selectedItems
{
    NSMutableSet *selectedItems = nil;
    
    if(m_selectedIndices.count > 0) {
        NSInteger itemCount = m_items.count;
        NSUInteger buffer[itemCount + 1];
        NSInteger count = [m_selectedIndices getIndexes:&(buffer[0]) maxCount:itemCount inIndexRange:NULL];
        
        if(count > 0) {
            selectedItems = [[NSMutableSet alloc] initWithCapacity:count];
            
            for(NSInteger index = 0; index < count; index++) {
                [selectedItems addObject:[m_items objectAtIndex:buffer[index]]];
            }
        }
    }
    
    return selectedItems;
}

- (void)setSelectedItems:(NSSet *)selectedItems
{
    NSMutableIndexSet *selectedIndices = [[NSMutableIndexSet alloc] init];
    
    if(selectedItems.count > 0 && m_items != nil) {
        for(id selectedItem in selectedItems) {
            NSInteger index = [m_items indexOfObject:selectedItem];
            
            if(index != NSNotFound) {
                [selectedIndices addIndex:index];
            }
        }
    }
    
    if(!MFEqual(m_selectedIndices, selectedIndices)) {
        m_selectedIndices = selectedIndices;
        [self.tableView reloadData];
    }
}

- (NSArray *)items
{
    return m_items;
}

- (void)setItems:(NSArray *)items
{
    if(!MFEqual(m_items, items)) {
        m_items = items;
        
        if(items.count > 0) {
            NSCharacterSet *chars = [NSCharacterSet alphanumericCharacterSet];
            NSMutableArray *sections = [[NSMutableArray alloc] init];
            NSMutableArray *index = [[NSMutableArray alloc] init];
            NSMutableArray *section = nil;
            NSString *lastIndex = nil;
            
            for(id item in items) {
                NSString *title = MFOptionPickerControllerGetItemTitle(item);
                NSString *nextIndex = [title substringToIndex:1].decomposedStringWithCanonicalMapping.uppercaseString;
                
                if(nextIndex.length != 1 || [nextIndex rangeOfCharacterFromSet:chars].location != 0) {
                    nextIndex = (lastIndex) ? lastIndex : @"A";
                }
                
                if(!lastIndex || ![lastIndex isEqualToString:nextIndex]) {
                    [index addObject:nextIndex];
                    lastIndex = nextIndex;
                    section = nil;
                }
                
                if(!section) {
                    section = [[NSMutableArray alloc] init];
                    [sections addObject:section];
                }
                
                [section addObject:item];
            }
            
            m_sections = sections;
            m_index = index;
        } else {
            m_index = nil;
            m_sections = nil;
        }
        
        self.selectedItems = self.selectedItems;
        [self.tableView reloadData];
    }
}

- (NSString *)sectionHeaderTitle
{
    return m_sectionHeaderTitle;
}

- (void)setSectionHeaderTitle:(NSString *)sectionHeaderTitle
{
    if(!MFEqual(m_sectionHeaderTitle, sectionHeaderTitle)) {
        m_sectionHeaderTitle = sectionHeaderTitle;
        [self.tableView reloadData];
    }
}

@synthesize userInfo = m_userInfo;
@synthesize maximumSelectedItems = m_maximumSelectedItems;

- (IBAction)complete:(id)sender
{
    if([m_delegate respondsToSelector:@selector(optionPickerControllerDidComplete:)]) {
        [m_delegate optionPickerControllerDidComplete:self];
    }
}

#pragma mark UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
}

#pragma mark UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return (m_allowsSearch || m_items.count > 100) ? m_index : nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)[m_sections objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    id item = [(NSArray *)[m_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSInteger index = [m_items indexOfObject:item];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        cell.backgroundColor = [UIColor themeBackgroundColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indentationWidth = 12.0F;
        cell.indentationLevel = 1;
        cell.textLabel.font = [UIFont themeFontOfSize:14.0F];
        cell.textLabel.textColor = [UIColor themeTextColor];
    }
    
    cell.accessoryType = ([m_selectedIndices containsIndex:index]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.textLabel.text = MFOptionPickerControllerGetItemTitle(item);
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (m_sectionHeaderTitle && section == 0) ? [MFSectionHeaderView preferredHeight] : 0.0F;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return (m_sectionHeaderTitle && section == 0) ? [[MFSectionHeaderView alloc] initWithTitle:m_sectionHeaderTitle] : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [(NSArray *)[m_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger index = [m_items indexOfObject:item];
    BOOL changed = NO;
    
    if(!tableView.allowsMultipleSelection && m_selectedIndices.count > 0) {
        NSInteger itemCount = m_items.count;
        NSUInteger buffer[itemCount + 1];
        NSInteger count = [m_selectedIndices getIndexes:&(buffer[0]) maxCount:itemCount inIndexRange:NULL];
        
        if(count > 0) {
            for(NSInteger i = 0; i < count; i++) {
                if(buffer[i] != index) {
                    id sectionItem = [m_items objectAtIndex:buffer[i]];
                    
                    for(NSInteger sectionIndex = 0, sectionCount = m_sections.count; sectionIndex < sectionCount; sectionIndex++) {
                        NSInteger sectionRow = [[(NSArray *)m_sections objectAtIndex:sectionIndex] indexOfObject:sectionItem];
                        
                        if(sectionRow != NSNotFound) {
                            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sectionRow inSection:sectionIndex]].accessoryType = UITableViewCellAccessoryNone;
                            break;
                        }
                    }
                    
                    [m_selectedIndices removeIndex:buffer[i]];
                    changed = YES;
                }
            }
        }
    }
    
    if([m_selectedIndices containsIndex:index]) {
        if(m_selectedIndices.count > 1 || m_allowsEmptySelection) {
            [m_selectedIndices removeIndex:index];
            cell.accessoryType = UITableViewCellAccessoryNone;
            changed = YES;
        }
    } else if(m_maximumSelectedItems == 0 || m_selectedIndices.count < m_maximumSelectedItems ||
             ([m_delegate respondsToSelector:@selector(optionPickerController: mustSelectItem:)] &&
              [m_delegate optionPickerController:self mustSelectItem:item])) {
        [m_selectedIndices addIndex:index];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        changed = YES;
    }
    
    if(changed && [m_delegate respondsToSelector:@selector(optionPickerControllerDidChange: atItem:)]) {
        [m_delegate optionPickerControllerDidChange:self atItem:item];
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
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 46.0F;
    tableView.backgroundColor = [UIColor themeBackgroundColor];
    tableView.separatorColor = [UIColor themeSeparatorColor];
    tableView.allowsMultipleSelection = NO;
    
    self.view = tableView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if([m_delegate respondsToSelector:@selector(optionPickerControllerDidClose:)]) {
        [m_delegate optionPickerControllerDidClose:self];
    }
    
    [super viewWillDisappear:animated];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        m_selectedIndices = [[NSMutableIndexSet alloc] init];
    }
    
    return self;
}

@end
