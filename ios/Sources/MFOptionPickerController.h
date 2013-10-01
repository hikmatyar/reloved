/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFOptionPickerController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    @private
    BOOL m_allowsEmptySelection;
    BOOL m_allowsSearch;
    NSArray *m_items;
    NSArray *m_index;
    NSArray *m_sections;
    NSMutableIndexSet *m_selectedIndices;
    NSString *m_sectionHeaderTitle;
}

@property (nonatomic, assign) BOOL allowsEmptySelection;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL allowsSearch;
@property (nonatomic, retain) id selectedItem;
@property (nonatomic, retain) NSSet *selectedItems;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSString *sectionHeaderTitle;

@end
