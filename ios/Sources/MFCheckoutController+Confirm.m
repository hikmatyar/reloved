/* Copyright (c) 2013 Meep Factory OU */

#import "MFCart.h"
#import "MFCheckoutController+Confirm.h"
#import "MFCheckoutPageView.h"
#import "MFDatabase+Post.h"
#import "MFPost.h"
#import "MFPostEditableTableViewCell.h"
#import "MFSectionHeaderView.h"
#import "MFTableView.h"
#import "MFTableViewCell.h"
#import "MFWebController.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UITableView+Additions.h"

#define SECTION_SUMMARY 0
#define SECTION_SUMMARY_ROW_ITEMS 0
#define SECTION_SUMMARY_ROW_SHIPPING 1
#define SECTION_SUMMARY_ROW_FEE 2
#define SECTION_SUMMARY_ROW_TOTAL 3
#define SECTION_PAYMENT 1
#define SECTION_SHIPPING 2
#define SECTION_POSTS 3
#define SECTION_DELIVERY 4

#define CELL_SUMMARY @"summary"
#define CELL_SUMMARY_PLUS_HELP @"summary_help"
#define CELL_SUMMARY_PLUS_SEPARATOR @"summary_separator"
#define CELL_PAYMENT @"payment"
#define CELL_SHIPPING @"shipping"
#define CELL_POSTS @"post"
#define CELL_DELIVERY @"delivery"

@interface MFCheckoutController_Confirm : MFCheckoutPageView <UITableViewDataSource, UITableViewDelegate>
{
    @private
    MFTableView *m_tableView;
}

@end

@implementation MFCheckoutController_Confirm

#pragma mark MFCheckoutPageView

- (id)initWithFrame:(CGRect)frame controller:(MFCheckoutController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
        m_tableView = [[MFTableView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, frame.size.width, frame.size.height)];
        m_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        m_tableView.backgroundColor = [UIColor themeBackgroundColor];
        m_tableView.dataSource = self;
        m_tableView.delegate = self;
        m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:m_tableView];
    }
    
    return self;
}

- (void)cartDidChange
{
    [m_tableView reloadData];
}

#pragma mark MFPageView

- (void)pageWillAppear
{
    [super pageWillAppear];
    [m_tableView clearSelection];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case SECTION_SUMMARY:
            return 4;
        case SECTION_PAYMENT:
            return 1;
        case SECTION_SHIPPING:
            return 1;
        case SECTION_POSTS:
            return 0;
        case SECTION_DELIVERY:
            return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section) {
        case SECTION_SUMMARY: {
            BOOL withSeparator = (indexPath.row == SECTION_SUMMARY_ROW_TOTAL) ? YES : NO;
            BOOL withHelp = (indexPath.row == SECTION_SUMMARY_ROW_SHIPPING || indexPath.row == SECTION_SUMMARY_ROW_FEE) ? YES : NO;
            NSString *identifier = (withHelp) ? CELL_SUMMARY_PLUS_HELP : ((withSeparator) ? CELL_SUMMARY_PLUS_SEPARATOR : CELL_SUMMARY);
            MFTableViewCell *cell = (MFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            
            if(!cell) {
                cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(withHelp) ? @"Checkout-Help.png" : @"Checkout-NoHelp.png"]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont themeFontOfSize:13.0F];
                cell.detailTextLabel.font = [UIFont themeFontOfSize:13.0F];
                cell.backgroundColor = [UIColor themeButtonBackgroundColor];
                
                if(withSeparator) {
                    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 1.0F)];
                    
                    separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
                    separatorView.backgroundColor = [UIColor themeSeparatorColor];
                    [cell.contentView addSubview:separatorView];
                }
            }
            
            switch(indexPath.row) {
                case SECTION_SUMMARY_ROW_ITEMS:
                    cell.textLabel.text = NSLocalizedString(@"Checkout.Label.Items", nil);
                    cell.detailTextLabel.text = @"123";
                    break;
                case SECTION_SUMMARY_ROW_SHIPPING:
                    cell.textLabel.text = NSLocalizedString(@"Checkout.Label.ShippingAndPacking", nil);
                    cell.detailTextLabel.text = @"1";
                    break;
                case SECTION_SUMMARY_ROW_FEE:
                    cell.textLabel.text = NSLocalizedString(@"Checkout.Label.TransactionFee", nil);
                    cell.detailTextLabel.text = @"123";
                    break;
                case SECTION_SUMMARY_ROW_TOTAL:
                    cell.textLabel.text = NSLocalizedString(@"Checkout.Label.Total", nil);
                    cell.detailTextLabel.text = @"1234";
                    break;
            }
            
            return cell;
        } break;
        case SECTION_PAYMENT: {
            MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_PAYMENT];
            
            if(!cell) {
                cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_PAYMENT];
                //cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Disclosure-Indicator.png"]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor themeButtonBackgroundColor];
                //cell.backgroundNormalColor = [UIColor themeButtonBackgroundColor];
                //cell.backgroundHighlightColor = [UIColor themeButtonBackgroundHighlightColor];
                cell.textLabel.font = [UIFont themeFontOfSize:13.0F];
            }
            
            cell.textLabel.text = @"Visa ****-1234"; // TODO:
            
            return cell;
        } break;
        case SECTION_SHIPPING: {
            MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_SHIPPING];
            
            if(!cell) {
                cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_SHIPPING];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor themeButtonBackgroundColor];
                cell.textLabel.font = [UIFont themeBoldFontOfSize:13.0F];
                cell.detailTextLabel.font = [UIFont themeFontOfSize:13.0F];
                cell.detailTextLabel.numberOfLines = 0;
            }
            
            cell.textLabel.text = @"Samreen Ghani";
            cell.detailTextLabel.text = @"Flat 505, 7 Garden Walk\nLondon ABCDE E\nUnited Kingdom"; // TODO:
            
            return cell;
        } break;
        case SECTION_POSTS: {
            
        } break;
        case SECTION_DELIVERY: {
            MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_DELIVERY];
            
            if(!cell) {
                cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_DELIVERY];
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Disclosure-Indicator.png"]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundNormalColor = [UIColor themeButtonBackgroundColor];
                cell.backgroundHighlightColor = [UIColor themeButtonBackgroundHighlightColor];
                cell.textLabel.font = [UIFont themeFontOfSize:13.0F];
                cell.textLabel.text = NSLocalizedString(@"Checkout.Action.Delivery", nil);
            }
            
            return cell;
        } break;
    }
    
    return nil;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section) {
        case SECTION_SHIPPING:
            return 3.0F * 26.0F;
        case SECTION_POSTS:
            return [MFPostEditableTableViewCell preferredHeight];
        case SECTION_DELIVERY:
            return 45.0F;
    }
    
    return 26.0F;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section != SECTION_DELIVERY) ? [MFSectionHeaderView preferredHeight] : 0.0F;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch(section) {
        case SECTION_SUMMARY:
            return [[MFSectionHeaderView alloc] initWithTitle:NSLocalizedString(@"Checkout.Label.OrderSummary", nil)];
        case SECTION_PAYMENT:
            return [[MFSectionHeaderView alloc] initWithTitle:NSLocalizedString(@"Checkout.Label.PaymentMethod", nil)];
        case SECTION_SHIPPING:
            return [[MFSectionHeaderView alloc] initWithTitle:NSLocalizedString(@"Checkout.Label.ShippingInfo", nil)];
        case SECTION_POSTS:
            return [[MFSectionHeaderView alloc] initWithTitle:NSLocalizedString(@"Checkout.Label.DeliveryDetails", nil)];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section) {
        case SECTION_SUMMARY:
            switch(indexPath.row) {
                case SECTION_SUMMARY_ROW_FEE:
                    [m_controller.navigationController pushViewController:
                        [[MFWebController alloc] initWithContentsOfFile:@"Transaction-Fee"
                                                                  title:NSLocalizedString(@"Checkout.Label.TransactionFee", nil)] animated:YES];
                    break;
                case SECTION_SUMMARY_ROW_SHIPPING:
                    [m_controller.navigationController pushViewController:
                        [[MFWebController alloc] initWithContentsOfFile:@"Shipping-Info"
                                                                  title:NSLocalizedString(@"Checkout.Label.ShippingAndPacking", nil)] animated:YES];
                    break;
            }
            break;
        case SECTION_PAYMENT:
            break;
        case SECTION_SHIPPING:
            break;
        case SECTION_POSTS:
            break;
        case SECTION_DELIVERY:
            [m_controller.navigationController pushViewController:
                        [[MFWebController alloc] initWithContentsOfFile:@"Shipping-Info"
                                                                  title:NSLocalizedString(@"Checkout.Label.DeliveryDetails", nil)] animated:YES];
            break;
    }
}

@end

#pragma mark -

@implementation MFCheckoutController(Confirm)

- (MFCheckoutPageView *)createConfirmPageView
{
    return [[MFCheckoutController_Confirm alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
