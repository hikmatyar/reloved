/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFListController : UIViewController
{
    @private
    NSArray *m_lines;
}

- (id)initWithTitle:(NSString *)title lines:(NSArray *)lines;

@property (nonatomic, retain, readonly) NSArray *lines;

@end
