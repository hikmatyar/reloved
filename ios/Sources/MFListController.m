/* Copyright (c) 2013 Meep Factory OU */

#import "MFListController.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#define SIDE_PADDING 17.0F
#define LINE_HEIGHT 20.0F

@implementation MFListController

- (id)initWithTitle:(NSString *)title lines:(NSArray *)lines
{
    self = [super init];
    
    if(self) {
        m_lines = lines;
        self.title = title;
    }
    
    return self;
}

@synthesize lines = m_lines;

#pragma mark UIView

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    CGFloat offset = SIDE_PADDING;
    
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor themeTextBackgroundColor];
    
    for(NSString *comment in m_lines) {
        UIImageView *dotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PADDING, offset + roundf(0.5F * (LINE_HEIGHT - 16.0F)), 16.0F, 16.0F)];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PADDING + 20.0F, offset, 320.0F - 20.0F - SIDE_PADDING, LINE_HEIGHT)];
        
        dotImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        dotImageView.image = [UIImage imageNamed:@"Blue-Dot.png"];
        [view addSubview:dotImageView];
        textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        textLabel.font = [UIFont themeFontOfSize:13.0F];
        textLabel.numberOfLines = 0;
        textLabel.text = comment;
        textLabel.textColor = [UIColor themeTextColor];
        [textLabel sizeToFit];
        textLabel.frame = CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, textLabel.frame.size.width, ceilf(textLabel.frame.size.height / LINE_HEIGHT) * LINE_HEIGHT);
        [view addSubview:textLabel];
        
        offset += fmaxf(LINE_HEIGHT, textLabel.frame.size.height);
    }
    
    self.view = view;
}

@end
