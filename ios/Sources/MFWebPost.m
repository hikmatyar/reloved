/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrand.h"
#import "MFColor.h"
#import "MFCondition.h"
#import "MFDatabase+Brand.h"
#import "MFDatabase+Color.h"
#import "MFDatabase+Size.h"
#import "MFDatabase+Type.h"
#import "MFPost.h"
#import "MFSize.h"
#import "MFType.h"
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
        m_post = post;
    }
    
    return self;
}

@synthesize post = m_post;

@dynamic brand;

- (MFBrand *)brand
{
    return [[MFDatabase sharedDatabase] brandForIdentifier:m_post.brandId];
}

@dynamic colors;

- (NSArray *)colors
{
    return [[MFDatabase sharedDatabase] colorsForIdentifiers:m_post.colorIds];
}

@dynamic condition;

- (MFCondition *)condition
{
    NSString *identifier = m_post.conditionId;
    
    for(MFCondition *condition in [MFCondition allConditions]) {
        if([identifier isEqualToString:condition.identifier]) {
            return condition;
        }
    }
    
    return nil;
}

@dynamic size;

- (MFSize *)size
{
    return [[MFDatabase sharedDatabase] sizeForIdentifier:m_post.sizeId];
}

@dynamic types;

- (NSArray *)types
{
    return [[MFDatabase sharedDatabase] typesForIdentifiers:m_post.typeIds];
}

@end
