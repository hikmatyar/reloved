/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@class MFPostFooterView;

@protocol MFPostFooterViewDelegate <NSObject>

@optional

- (void)footerViewDidSelectSave:(MFPostFooterView *)footerView;
- (void)footerViewDidSelectShare:(MFPostFooterView *)footerView;

@end
