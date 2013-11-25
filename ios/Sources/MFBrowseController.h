/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrowseFilterControllerDelegate.h"
#import "MFFeedController.h"

typedef enum _MFBrowseControllerScope {
    kMFBrowseControllerScopeEditorial = 0,
    kMFBrowseControllerScopeBookmarks,
    kMFBrowseControllerScopeAll,
    kMFBrowseControllerScopeNew
} MFBrowseControllerScope;

@interface MFBrowseController : MFFeedController <MFBrowseFilterControllerDelegate>
{
    @private
    MFBrowseControllerScope m_scope;
    
}

- (id)initWithScope:(MFBrowseControllerScope)scope;

@property (nonatomic, assign) MFBrowseControllerScope scope;

@end
