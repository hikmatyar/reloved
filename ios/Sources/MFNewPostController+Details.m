/* Copyright (c) 2013 Meep Factory OU */

#import "MFNewPostController+Details.h"
#import "MFPageView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@interface MFNewPostController_Details : MFPageView
{
    @private
}

@end

@implementation MFNewPostController_Details

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
    }
    
    return self;
}

@end

#pragma mark -

@implementation MFNewPostController(Details)

- (MFPageView *)createDetailsPageView
{
    return [[MFNewPostController_Details alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
}

@end
