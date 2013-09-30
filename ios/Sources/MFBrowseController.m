/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrowseController.h"
#import "MFBrowseFilterController.h"
#import "MFWebFeed.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define TAG_SCOPE_LABEL 10000
#define TAG_SCOPE_PICKER 10001

@implementation MFBrowseController

- (id)initWithScope:(MFBrowseControllerScope)scope
{
    MFWebFeed *feed = nil;
    
    switch(scope) {
        case kMFBrowseControllerScopeEditorial:
            feed = [MFWebFeed sharedFeedOfKind:kMFWebFeedKindOnlyEditorial];
            break;
        case kMFBrowseControllerScopeNew:
            feed = [MFWebFeed sharedFeedOfKind:kMFWebFeedKindOnlyNew];
            break;
        case kMFBrowseControllerScopeAll:
            feed = [MFWebFeed sharedFeedOfKind:kMFWebFeedKindAll];
            break;
    }
    
    self = [self initWithFeed:feed];
    
    if(self) {
        m_scope = scope;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Filter"] style:UIBarButtonItemStyleBordered target:self action:@selector(filter:)];
        self.navigationItem.title = NSLocalizedString(@"Browse.Title", nil);
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
        NSInteger selectedIndex;
        MFWebFeed *feed = nil;
        
        m_scope = scope;
        
        switch(m_scope) {
            case kMFBrowseControllerScopeEditorial:
                feed = [MFWebFeed sharedFeedOfKind:kMFWebFeedKindOnlyEditorial];
                selectedIndex = 0;
                break;
            case kMFBrowseControllerScopeNew:
                feed = [MFWebFeed sharedFeedOfKind:kMFWebFeedKindOnlyNew];
                selectedIndex = 1;
                break;
            case kMFBrowseControllerScopeAll:
                feed = [MFWebFeed sharedFeedOfKind:kMFWebFeedKindAll];
                selectedIndex = 2;
                break;
        }
        
        if(scopePicker.selectedSegmentIndex != selectedIndex) {
            scopePicker.selectedSegmentIndex = selectedIndex;
        }
        
        self.feed = feed;
    }
}

- (IBAction)filter:(id)sender
{
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[[MFBrowseFilterController alloc] init]];
    
    controller.navigationBar.translucent = self.navigationController.navigationBar.translucent;
    [self presentViewController:controller animated:YES completion:NULL];
}

- (IBAction)scope:(id)sender
{
    switch(self.scopePicker.selectedSegmentIndex) {
        case 0:
            self.scope = kMFBrowseControllerScopeEditorial;
            break;
        case 1:
            self.scope = kMFBrowseControllerScopeNew;
            break;
        case 2:
            self.scope = kMFBrowseControllerScopeAll;
            break;
    }
}

#pragma mark UIViewController

- (void)loadView
{
    UISegmentedControl *scopePicker = [[UISegmentedControl alloc] initWithItems:
        [NSArray arrayWithObjects:
            NSLocalizedString(@"Browse.Action.ShowEditorial", nil),
            NSLocalizedString(@"Browse.Action.ShowNew", nil),
            NSLocalizedString(@"Browse.Action.ShowAll", nil), nil]];
    UIView *scopeView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 62.0F)];
    UILabel *scopeLabel = [[UILabel alloc] initWithFrame:CGRectMake(-1.0F, 40.0F, 322.0F, 22.0F)];
    
    switch(m_scope) {
        case kMFBrowseControllerScopeEditorial:
            scopePicker.selectedSegmentIndex = 0;
            break;
        case kMFBrowseControllerScopeNew:
            scopePicker.selectedSegmentIndex = 1;
            break;
        case kMFBrowseControllerScopeAll:
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
    scopeLabel.font = [UIFont themeFontOfSize:11.0F];
    scopeLabel.layer.borderColor = [UIColor themeSeparatorColor].CGColor;
    scopeLabel.layer.borderWidth = 1.0F;
    scopeLabel.tag = TAG_SCOPE_LABEL;
    scopeLabel.textAlignment = NSTextAlignmentCenter;
    scopeLabel.textColor = [UIColor themeTextAlternativeColor];
    scopeLabel.text = NSLocalizedString(@"Browse.Format.Results.None", nil);
    [scopeView addSubview:scopeLabel];
    
    [super loadView];
    self.tableView.tableHeaderView = scopeView;
}

#pragma mark NSObject

- (id)init
{
    return [self initWithScope:kMFBrowseControllerScopeEditorial];
}

@end
