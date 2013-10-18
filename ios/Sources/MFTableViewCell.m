/* Copyright (c) 2013 Meep Factory OU */

#import "MFTableView.h"
#import "MFTableViewCell.h"

@implementation MFTableViewCell

- (id <MFTableView>)tableView
{
    UIView *superview = self;
    
    do {
        superview = superview.superview;
    } while(superview && ![superview isKindOfClass:[UITableView class]] && ![superview conformsToProtocol:@protocol(MFTableView)]);
    
    return ([superview conformsToProtocol:@protocol(MFTableView)]) ? (id <MFTableView>)superview : nil;
}

- (void)invalidateColors:(BOOL)state
{
    if(state) {
        if(m_backgroundHighlightColor) {
            self.backgroundColor = m_backgroundHighlightColor;
        }
    } else {
        if(m_backgroundNormalColor) {
            self.backgroundColor = m_backgroundNormalColor;
        }
    }
}

- (UIImage *)imageForURL:(NSURL *)URL
{
    return [self.tableView startLoadingForCell:self URL:URL error:nil exists:NULL];
}

- (UIImage *)imageForURL:(NSURL *)URL error:(NSError **)error exists:(BOOL *)exists
{
    if(error) {
        *error = nil;
    }
    
    if(exists) {
        *exists = NO;
    }
    
    return [self.tableView startLoadingForCell:self URL:URL error:error exists:exists];
}

- (void)prepareForDisplay
{
}

@synthesize backgroundNormalColor = m_backgroundNormalColor;
@synthesize backgroundHighlightColor = m_backgroundHighlightColor;

#pragma mark UITableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[self invalidateColors:selected];
	[super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[self invalidateColors:highlighted];
	[super setHighlighted:highlighted animated:animated];
}

#pragma mark UIView

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self prepareForDisplay];
}

@end
