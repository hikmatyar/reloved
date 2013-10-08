/* Copyright (c) 2013 Meep Factory OU */

#import "MFNewPostController+Price.h"
#import "MFNewPostPageView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@interface MFNewPostController_Price : MFNewPostPageView
{
    @private
}

@end

@implementation MFNewPostController_Price

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame controller:(MFNewPostController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
    }
    
    return self;
}

@end

#pragma mark -

@implementation MFNewPostController(Price)

- (MFNewPostPageView *)createPricePageView
{
    return [[MFNewPostController_Price alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F) controller:self];
}

@end
