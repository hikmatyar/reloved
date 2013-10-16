/* Copyright (c) 2013 Meep Factory OU */

#import "MFPostDetails.h"
#import "NSDictionary+Additions.h"

@implementation MFPostDetails

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        
    }
    
    return self;
}

#pragma mark MFWebRequestTransform

+ (id)parseFromObject:(id)object
{
    return ([object isKindOfClass:[NSDictionary class]]) ? [[self alloc] initWithAttributes:(NSDictionary *)object] : nil;
}

@end
