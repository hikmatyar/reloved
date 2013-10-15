/* Copyright (c) 2013 Meep Factory OU */

#import "MFPost.h"
#import "MFWebService+Post.h"

@implementation MFWebService(Post)

- (void)requestPostCreate:(MFMutablePost *)post target:(id)target usingBlock:(MFWebRequestBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    MFWebRequest *request;
    
    [parameters setValue:post.conditionId forKey:@"condition"];
    [parameters setValue:post.typeId forKey:@"type"];
    [parameters setValue:post.sizeId forKey:@"size"];
    [parameters setValue:post.brandId forKey:@"brand"];
    [parameters setValue:[post.colorIds componentsJoinedByString:@","] forKey:@"colors"];
    [parameters setValue:[post.mediaIds componentsJoinedByString:@","] forKey:@"media"];
    [parameters setValue:post.materials forKey:@"materials"];
    [parameters setValue:post.title forKey:@"title"];
    [parameters setValue:post.fit forKey:@"fit"];
    [parameters setValue:post.notes forKey:@"notes"];
    [parameters setValue:post.editorial forKey:@"editorial"];
    [parameters setValue:[NSNumber numberWithInteger:post.price] forKey:@"price"];
    [parameters setValue:[NSNumber numberWithInteger:post.priceOriginal] forKey:@"price_original"];
    [parameters setValue:post.currency forKey:@"currency"];
    [parameters setValue:[post.tags componentsJoinedByString:@","] forKey:@"tags"];
    
    request = [[MFWebRequest alloc] initWithService:self
                                               mode:kMFWebRequestModeJsonPost
                                             target:target
                                               path:@"/user/post/create"
                                         parameters:parameters];
    request.block = block;
    request.transform = [MFPost class];
    [self addRequest:request];
}

- (void)requestPostEdit:(MFPost *)post changes:(MFPostChange)changes target:(id)target usingBlock:(MFWebRequestBlock)block
{
    MFWebRequest *request = [[MFWebRequest alloc] initWithService:self
                                                             mode:kMFWebRequestModeJsonPost
                                                           target:target
                                                             path:@"/user/post/edit"
                                                       parameters:[post attributesForChanges:changes]];
    
    request.block = block;
    request.transform = [MFPost class];
    [self addRequest:request];
}

@end