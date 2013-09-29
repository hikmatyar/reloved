/* Copyright (c) 2013 Meep Factory OU */

#import "MFPost.h"
#import "MFWebPost.h"

@implementation MFWebPost

- (id)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    
    if(self) {
        
    }
    
    return self;
}

- (id)initWithPost:(MFPost *)post
{
    self = [self initWithIdentifier:post.identifier];
    
    if(self) {
    }
    
    return self;
}

@end
