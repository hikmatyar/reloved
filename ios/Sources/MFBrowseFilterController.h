/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

typedef enum _MFBrowseFilterControllerCategory {
    kMFBrowseFilterControllerCategorySize = 0,
    kMFBrowseFilterControllerCategoryType,
    kMFBrowseFilterControllerCategoryColor
} MFBrowseFilterControllerCategory;

#define kMFBrowseFilterControllerCategoryMin kMFBrowseFilterControllerCategoryColor
#define kMFBrowseFilterControllerCategoryMax kMFBrowseFilterControllerCategoryType

@protocol MFBrowseFilterControllerDelegate;

@interface MFBrowseFilterController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    @private
    MFBrowseFilterControllerCategory m_category;
    __unsafe_unretained id <MFBrowseFilterControllerDelegate> m_delegate;
    NSMutableSet *m_excludeColors;
    NSMutableSet *m_excludeSizes;
    NSMutableSet *m_excludeTypes;
}

- (id)initWithCategory:(MFBrowseFilterControllerCategory)category;
- (id)initWithDelegate:(id <MFBrowseFilterControllerDelegate>)delegate;

@property (nonatomic, assign) id <MFBrowseFilterControllerDelegate> delegate;

@end
