/* Copyright (c) 2013 Meep Factory OU */

#import "MFCart.h"
#import "MFCheckoutController+Cart.h"
#import "MFCheckoutPageView.h"
#import "MFDatabase+Post.h"
#import "MFMoney.h"
#import "MFPost.h"
#import "MFPostController.h"
#import "MFPostEditableTableViewCell.h"
#import "MFTableView.h"
#import "MFWebFeed.h"
#import "MFWebPost.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define CELL_IDENTIFIER @"cell"

#define ACTION_WIDTH 60.0F
#define HEADER_HEIGHT 28.0F
#define FOOTER_HEIGHT 54.0F

@interface MFCheckoutController_Cart : MFCheckoutPageView <UITableViewDataSource, UITableViewDelegate>
{
    @private
    UIButton *m_actionButton;
    UILabel *m_headerLabel;
    MFTableView *m_tableView;
    UILabel *m_footerLabel;
    BOOL m_updating;
}

@end

@implementation MFCheckoutController_Cart

- (IBAction)action:(id)sender
{
    if(m_tableView.editing) {
        m_actionButton.selected = NO;
        [m_tableView setEditing:NO animated:YES];
    } else {
        m_actionButton.selected = YES;
        [m_tableView setEditing:YES animated:YES];
    }
}

#pragma mark MFCheckoutPageView

- (id)initWithFrame:(CGRect)frame controller:(MFCheckoutController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
        UIView *separatorView;
        
        m_headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(ACTION_WIDTH, 0.0F, frame.size.width - 2.0F * ACTION_WIDTH, HEADER_HEIGHT)];
        m_headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        m_headerLabel.font = [UIFont themeFontOfSize:14.0F];
        m_headerLabel.textAlignment = NSTextAlignmentCenter;
        m_headerLabel.textColor = [UIColor themeTextColor];
        [self addSubview:m_headerLabel];
        
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, HEADER_HEIGHT - 1.0F, frame.size.width, 1.0F)];
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        separatorView.backgroundColor = [UIColor themeSeparatorColor];
        [self addSubview:separatorView];
        
        m_actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        m_actionButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        m_actionButton.frame = CGRectMake(frame.size.width - ACTION_WIDTH, 0.0F, ACTION_WIDTH, HEADER_HEIGHT);
        m_actionButton.titleLabel.font = [UIFont themeFontOfSize:14.0F];
        [m_actionButton setTitleColor:[UIColor themeButtonActionColor] forState:UIControlStateNormal];
        [m_actionButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [m_actionButton setTitle:NSLocalizedString(@"Checkout.Action.Edit", nil) forState:UIControlStateNormal];
        [m_actionButton setTitle:NSLocalizedString(@"Checkout.Action.Done", nil) forState:UIControlStateSelected];
        [self addSubview:m_actionButton];
        
        m_tableView = [[MFTableView alloc] initWithFrame:CGRectMake(0.0F, HEADER_HEIGHT, frame.size.width, frame.size.height - HEADER_HEIGHT - FOOTER_HEIGHT)];
        m_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        m_tableView.backgroundColor = [UIColor themeBackgroundColor];
        m_tableView.separatorColor = [UIColor themeSeparatorColor];
        m_tableView.dataSource = self;
        m_tableView.delegate = self;
        m_tableView.rowHeight = [MFPostEditableTableViewCell preferredHeight];
        
        if([m_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            m_tableView.separatorInset = UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F);
        }
        
        [self addSubview:m_tableView];
        
        m_footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0F, frame.size.height - FOOTER_HEIGHT, frame.size.width, FOOTER_HEIGHT)];
        m_footerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        m_footerLabel.font = [UIFont themeFontOfSize:14.0F];
        m_footerLabel.numberOfLines = 0;
        m_footerLabel.textAlignment = NSTextAlignmentCenter;
        m_footerLabel.textColor = [UIColor themeTextColor];
        [self addSubview:m_footerLabel];
        
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, frame.size.height - FOOTER_HEIGHT, frame.size.width, 1.0F)];
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        separatorView.backgroundColor = [UIColor themeSeparatorColor];
        [self addSubview:separatorView];
    }
    
    return self;
}

- (void)cartDidChange
{
    NSArray *posts = [[MFDatabase sharedDatabase] postsForIdentifiers:m_controller.cart.postIds];
    NSMutableAttributedString *footer = [[NSMutableAttributedString alloc] init];
    NSInteger count = posts.count;
    NSString *currency = nil;
    NSInteger total = 0;
    MFMoney *price;
    
    for(MFPost *post in posts) {
        total += post.price;
        currency = post.currency;
    }
    
    price = [[MFMoney alloc] initWithValue:total currency:currency];
    
    [footer beginEditing];
    [footer appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",
        [NSString stringWithFormat:NSLocalizedString(@"Checkout.Format.Total", nil), price.localizedString]] attributes:
        [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeBoldFontOfSize:14.0F], NSFontAttributeName, nil]]];
    [footer appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Checkout.Hint.Total", nil) attributes:
        [NSDictionary dictionaryWithObjectsAndKeys:[UIFont themeFontOfSize:14.0F], NSFontAttributeName, nil]]];
    [footer endEditing];
    
    m_headerLabel.text = [NSString stringWithFormat:NSLocalizedString((posts.count == 1) ? @"Checkout.Format.NumberOfItems" : @"Checkout.Format.NumberOfItems.Plural", nil), count];
    m_footerLabel.attributedText = footer;
    
    if(!m_updating) {
        [m_tableView reloadData];
    }
}

- (BOOL)canContinue
{
    return (m_controller.cart.postIds.count > 0) ? YES : NO;
}

#pragma mark MFPageView

- (void)pageWillAppear
{
    [super pageWillAppear];
    
    if(m_tableView.editing) {
        m_actionButton.selected = NO;
        [m_tableView setEditing:NO animated:NO];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_controller.cart.postIds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFPost *post = [[MFDatabase sharedDatabase] postForIdentifier:[m_controller.cart.postIds objectAtIndex:indexPath.row]];
    MFPostEditableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if(!cell) {
        cell = [[MFPostEditableTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.post = post;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        MFPost *post = [[MFDatabase sharedDatabase] postForIdentifier:[m_controller.cart.postIds objectAtIndex:indexPath.row]];
        
        m_updating = YES;
        [[[MFWebPost alloc] initWithPost:post] setIncludedInCart:NO];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        m_updating = NO;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return YES;
}

#pragma mark UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"Checkout.Action.Remove", nil);
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFPost *post = [[MFDatabase sharedDatabase] postForIdentifier:[m_controller.cart.postIds objectAtIndex:indexPath.row]];
    
    if(post) {
        MFPostController *controller = [[MFPostController alloc] initWithPost:[[MFWebPost alloc] initWithPost:post]];
        
        [m_controller.navigationController pushViewController:controller animated:YES];
    }
}

@end

#pragma mark -

@implementation MFCheckoutController(Cart)

- (MFCheckoutPageView *)createCartPageView
{
    return [[MFCheckoutController_Cart alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
