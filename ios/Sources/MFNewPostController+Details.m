/* Copyright (c) 2013 Meep Factory OU */

#import "MFNewPostController+Details.h"
#import "MFNewPostPageView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@interface MFNewPostController_Details : MFNewPostPageView
{
    @private
}

@end

@implementation MFNewPostController_Details

#pragma mark MFNewPostPageView

- (id)initWithFrame:(CGRect)frame controller:(MFNewPostController *)controller
{
    self = [super initWithFrame:frame controller:controller];
    
    if(self) {
    }
    
    return self;
}

@end

#pragma mark -

@implementation MFNewPostController(Details)

- (MFNewPostPageView *)createDetailsPageView
{
    return [[MFNewPostController_Details alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
}

@end
