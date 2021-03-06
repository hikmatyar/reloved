/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrowseController.h"
#import "MFBrowseFilterController.h"
#import "MFDatabase+Size.h"
#import "MFDatabase+Type.h"
#import "MFNewPostController.h"
#import "MFPreferences.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSize.h"
#import "MFTableView.h"
#import "MFType.h"
#import "MFWebFeed.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIViewController+MFSideMenuAdditions.h"

#define TAG_SCOPE_LABEL 10000
#define TAG_SCOPE_PICKER 10001

@implementation MFBrowseController

- (NSArray *)filters
{
    MFPreferences *preferences = [MFPreferences sharedPreferences];
    MFDatabase *database = [MFDatabase sharedDatabase];
    NSMutableArray *filters = nil;
    NSArray *excludeSet;
    
    if((excludeSet = preferences.excludeSizes) != nil && excludeSet.count > 0) {
        for(MFSize *size in database.sizes) {
            if(![excludeSet containsObject:size.identifier]) {
                if(!filters) {
                    filters = [[NSMutableArray alloc] init];
                }
                
                [filters addObject:size];
            }
        }
    }
    
    if((excludeSet = preferences.excludeTypes) != nil && excludeSet.count > 0) {
        for(MFType *type in database.types) {
            if(![excludeSet containsObject:type.identifier]) {
                if(!filters) {
                    filters = [[NSMutableArray alloc] init];
                }
                
                [filters addObject:type];
            }
        }
    }
    
    // HACK: Disabled, because of no info button
    return nil;
    //return filters;
}

- (MFWebFeed *)feedForScope:(MFBrowseControllerScope)scope
{
    switch(scope) {
        case kMFBrowseControllerScopeEditorial:
            return [MFWebFeed sharedFeedOfKind:kMFWebFeedKindOnlyEditorial filters:self.filters cache:YES];
        case kMFBrowseControllerScopeNew:
            return [MFWebFeed sharedFeedOfKind:kMFWebFeedKindOnlyNew filters:self.filters cache:YES];
        case kMFBrowseControllerScopeAll:
            return [MFWebFeed sharedFeedOfKind:kMFWebFeedKindAll filters:self.filters cache:YES];
        case kMFBrowseControllerScopeBookmarks:
            return [MFWebFeed sharedFeedOfKind:kMFWebFeedKindBookmarks];
    }
    
    return nil;
}

- (id)initWithScope:(MFBrowseControllerScope)scope
{
    MFWebFeed *feed = [self feedForScope:scope];
    
    self = [self initWithFeed:feed];
    
    if(self) {
        m_scope = scope;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menu:)];
       // self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:
            // [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Filter"] style:UIBarButtonItemStyleBordered target:self action:@selector(filter:)],
            // [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Sell"] style:UIBarButtonItemStyleBordered target:self action:@selector(sell:)], nil];
        // self.navigationItem.title = [NSLocalizedString(@"Browse.Title", nil);
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Navigation-Logo"]];
    }
    
    return self;
}

- (UILabel *)scopeLabel
{
    return (UILabel *)[self.tableView.tableHeaderView viewWithTag:TAG_SCOPE_LABEL];
}

- (UISegmentedControl *)scopePicker
{
    return (UISegmentedControl *)[self.tableView.tableHeaderView viewWithTag:TAG_SCOPE_PICKER];
}

- (void)updateScopeLabel:(NSInteger)value
{
    self.scopeLabel.text = [NSString stringWithFormat:
        NSLocalizedString((value > 1) ? @"Browse.Format.Results.Plural" : ((value == 1) ? @"Browse.Format.Results" : @"Browse.Format.Results.None"), nil), value];
}

@dynamic scope;

- (MFBrowseControllerScope)scope
{
    return m_scope;
}

- (void)setScope:(MFBrowseControllerScope)scope
{
    if(m_scope != scope) {
        UISegmentedControl *scopePicker = self.scopePicker;
        MFWebFeed *feed = [self feedForScope:scope];
        NSInteger selectedIndex;
        
        m_scope = scope;
        
        switch(m_scope) {
            case kMFBrowseControllerScopeEditorial:
                selectedIndex = 0;
                break;
            case kMFBrowseControllerScopeAll:
                selectedIndex = 1;
                break;
            case kMFBrowseControllerScopeNew:
            case kMFBrowseControllerScopeBookmarks:
                selectedIndex = 2;
                break;
        }
        
        if(scopePicker.selectedSegmentIndex != selectedIndex) {
            scopePicker.selectedSegmentIndex = selectedIndex;
        }
        
        self.feed = feed;
    }
}

- (IBAction)menu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:NULL];
}

- (IBAction)filter:(id)sender
{
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[[MFBrowseFilterController alloc] initWithDelegate:self]];
 
    controller.navigationBar.translucent = self.navigationController.navigationBar.translucent;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:NULL];
}

- (IBAction)sell:(id)sender
{
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[[MFNewPostController alloc] init]];
 
    controller.navigationBar.translucent = self.navigationController.navigationBar.translucent;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:NULL];
}

- (IBAction)scope:(id)sender
{
    switch(self.scopePicker.selectedSegmentIndex) {
        case 0:
            self.scope = kMFBrowseControllerScopeEditorial;
            break;
        case 1:
            self.scope = kMFBrowseControllerScopeAll;
            break;
        case 2:
            self.scope = kMFBrowseControllerScopeBookmarks; //kMFBrowseControllerScopeNew;
            break;
    }
}

#pragma mark MFFeedController

- (void)feedDidChange
{
    [self updateScopeLabel:self.feed.numberOfResults];
    [super feedDidChange];
}

#pragma mark MFBrowseFilterControllerDelegate

- (void)filterControllerDidClose:(MFBrowseFilterController *)controller
{
    self.feed = [self feedForScope:m_scope];
}

#pragma mark UIViewController

- (void)loadView
{
    UISegmentedControl *scopePicker = [[UISegmentedControl alloc] initWithItems:
        [NSArray arrayWithObjects:
            NSLocalizedString(@"Browse.Action.ShowEditorial", nil),
            NSLocalizedString(@"Browse.Action.ShowAll", nil),
            NSLocalizedString(@"Browse.Action.Bookmarks", nil),
            //NSLocalizedString(@"Browse.Action.ShowNew", nil),
                nil]];
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0]];
    UIView *scopeView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 62.0F)];
    UILabel *scopeLabel = [[UILabel alloc] initWithFrame:CGRectMake(-1.0F, 40.0F, 322.0F, 22.0F)];
    
    switch(m_scope) {
        case kMFBrowseControllerScopeEditorial:
            scopePicker.selectedSegmentIndex = 0;
            break;
        case kMFBrowseControllerScopeAll:
            scopePicker.selectedSegmentIndex = 1;
            break;
        case kMFBrowseControllerScopeBookmarks:
        case kMFBrowseControllerScopeNew:
            scopePicker.selectedSegmentIndex = 2;
            break;
    }
    
    scopePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scopePicker.center = CGPointMake(160.0F, 20.0F);
    scopePicker.tag = TAG_SCOPE_PICKER;
    [scopePicker addTarget:self action:@selector(scope:) forControlEvents:UIControlEventValueChanged];
    [scopeView addSubview:scopePicker];
    
    scopeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    scopeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    scopeLabel.font = [UIFont themeFontOfSize:13.0F];
    scopeLabel.layer.borderColor = [UIColor themeSeparatorColor].CGColor;
    scopeLabel.layer.borderWidth = 1.0F;
    scopeLabel.tag = TAG_SCOPE_LABEL;
    scopeLabel.textAlignment = NSTextAlignmentCenter;
    scopeLabel.textColor = [UIColor themeTextAlternativeColor];
    scopeLabel.text = NSLocalizedString(@"Browse.Format.Results.None", nil);
    [scopeView addSubview:scopeLabel];
    
    [super loadView];
    self.tableView.tableHeaderView = scopeView;
    [self updateScopeLabel:self.feed.numberOfResults];
}

#pragma mark NSObject

- (id)init
{
    return [self initWithScope:kMFBrowseControllerScopeEditorial];
}

@end
