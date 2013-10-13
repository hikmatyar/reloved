/* Copyright (c) 2013 Meep Factory OU */

#import "MFMedia.h"
#import "NSDictionary+Additions.h"

#define KEY_IDENTIFIER @"id"
#define KEY_STATUS @"status"
#define KEY_SIZE @"size"

@implementation MFMedia

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_identifier = [attributes identifierForKey:KEY_IDENTIFIER];
        m_status = [attributes integerForKey:KEY_STATUS];
        m_size = [attributes integerForKey:KEY_SIZE];
    }
    
    return self;
}

@synthesize identifier = m_identifier;
@synthesize status = m_status;
@synthesize size = m_size;

#pragma mark MFWebRequestTransform

+ (id)parseFromObject:(id)object
{
    return ([object isKindOfClass:[NSDictionary class]]) ? [[self alloc] initWithAttributes:(NSDictionary *)object] : nil;
}

@end
