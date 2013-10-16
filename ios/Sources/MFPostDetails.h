/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequestTransform.h"

@interface MFPostDetails : NSObject <MFWebRequestTransform>
{
    @private
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
