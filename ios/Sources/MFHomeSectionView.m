/* Copyright (c) 2013 Meep Factory OU */

#import "MFHomeSectionView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@implementation MFHomeSectionView

+ (CGFloat)preferredHeight
{
    return 34.0F;
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.backgroundColor = [UIColor themeBackgroundColor];
    }
    
    return self;
}

@end
