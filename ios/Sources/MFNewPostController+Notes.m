/* Copyright (c) 2013 Meep Factory OU */

#import "MFNewPostController+Notes.h"
#import "MFPageView.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@interface MFNewPostController_Notes : MFPageView
{
    @private
}

@end

@implementation MFNewPostController_Notes

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

@implementation MFNewPostController(Notes)

- (MFPageView *)createNotesPageView
{
    return [[MFNewPostController_Notes alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
}

@end
