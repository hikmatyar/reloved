/* Copyright (c) 2013 Meep Factory OU */

#import "MFComment.h"
#import "MFCommentTableViewCell.h"
#import "MFPost.h"
#import "MFPostCommentsController.h"
#import "MFTableView.h"
#import "MFWebPost.h"

@implementation MFPostCommentsController

- (id)initWithPost:(MFWebPost *)post
{
    self = [super init];
    
    if(self) {
        m_post = post;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
        self.title = NSLocalizedString(@"PostComments.Title", nil);
    }
    
    return self;
}

@synthesize post = m_post;

- (IBAction)refresh:(id)sender
{
    [m_post startLoading];
}

- (void)postDidChange:(NSNotification *)notification
{
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark UITableViewDelegate

#pragma mark UIViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(postDidChange:) name:MFWebPostDidChangeNotification object:m_post];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center removeObserver:self name:MFWebPostDidChangeNotification object:m_post];
    [super viewWillDisappear:animated];
}

@end
