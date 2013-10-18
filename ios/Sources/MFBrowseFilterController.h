/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

typedef enum _MFBrowseFilterControllerCategory {
    kMFBrowseFilterControllerCategoryColor = 0,
    kMFBrowseFilterControllerCategorySize,
    kMFBrowseFilterControllerCategoryType
} MFBrowseFilterControllerCategory;

#define kMFBrowseFilterControllerCategoryMin kMFBrowseFilterControllerCategoryColor
#define kMFBrowseFilterControllerCategoryMax kMFBrowseFilterControllerCategoryType

@interface MFBrowseFilterController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    @private
    MFBrowseFilterControllerCategory m_category;
    NSMutableSet *m_excludeColors;
    NSMutableSet *m_excludeSizes;
    NSMutableSet *m_excludeTypes;
}

- (id)initWithCategory:(MFBrowseFilterControllerCategory)category;

@end
