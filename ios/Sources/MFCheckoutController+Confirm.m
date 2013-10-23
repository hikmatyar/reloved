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

#define SECTION_SUMMARY 0
#define SECTION_SUMMARY_ROW_ITEMS 0
#define SECTION_SUMMARY_ROW_SHIPPING 1
#define SECTION_SUMMARY_ROW_FEE 2
#define SECTION_SUMMARY_ROW_TOTAL 3
#define SECTION_PAYMENT 1
#define SECTION_SHIPPING 2
#define SECTION_DELIVERY 3

#define CELL_SUMMARY @"summary"
#define CELL_SUMMARY_PLUS_HELP @"summary_help"
#define CELL_PAYMENT @"payment"
#define CELL_SHIPPING @"shipping"

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
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
        case SECTION_DELIVERY:
            return 0;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section) {
        case SECTION_SUMMARY: {
            BOOL withHelp = (indexPath.row == SECTION_SUMMARY_ROW_SHIPPING || indexPath.row == SECTION_SUMMARY_ROW_FEE) ? YES : NO;
            MFTableViewCell *cell = (MFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:(withHelp) ? CELL_SUMMARY_PLUS_HELP : CELL_SUMMARY];
            
            if(!cell) {
                cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:(withHelp) ? CELL_SUMMARY_PLUS_HELP : CELL_SUMMARY];
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(withHelp) ? @"Checkout-Help.png" : @"Checkout-NoHelp.png"]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont themeFontOfSize:13.0F];
                cell.detailTextLabel.font = [UIFont themeFontOfSize:13.0F];
                cell.backgroundColor = [UIColor themeButtonBackgroundColor];
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
        case SECTION_DELIVERY: {
            
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
    }
    
    return 26.0F;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [MFSectionHeaderView preferredHeight];
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
        case SECTION_DELIVERY:
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
        case SECTION_DELIVERY:
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
