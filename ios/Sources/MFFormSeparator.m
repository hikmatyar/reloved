/* Copyright (c) 2013 Meep Factory OU */

#import "MFFormSeparator.h"
#import "UIColor+Additions.h"

@implementation MFFormSeparator

- (id)initWithPosition:(CGFloat)position
{
    return [self initWithFrame:CGRectMake(0.0F, position, 320.0F, 1.0F)];
}

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor themeSeparatorColor];
    }
    
    return self;
}

@end
