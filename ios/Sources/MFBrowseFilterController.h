/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

typedef enum _MFBrowseFilterControllerCategory {
    kMFBrowseFilterControllerCategorySize = 0,
    kMFBrowseFilterControllerCategoryType
} MFBrowseFilterControllerCategory;

#define kMFBrowseFilterControllerCategoryMin kMFBrowseFilterControllerCategorySize
#define kMFBrowseFilterControllerCategoryMax kMFBrowseFilterControllerCategoryType

@interface MFBrowseFilterController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    @private
    MFBrowseFilterControllerCategory m_category;
    NSMutableSet *m_excludeSizes;
    NSMutableSet *m_excludeTypes;
}

- (id)initWithCategory:(MFBrowseFilterControllerCategory)category;

@end
