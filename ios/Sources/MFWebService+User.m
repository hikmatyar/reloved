/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebService+User.h"
#import "MFUserDetails.h"

@implementation MFWebService(User)

- (void)requestUserDetails:(NSString *)identifier target:(id)target usingBlock:(MFWebRequestBlock)block
{
    MFWebRequest *request = [[MFWebRequest alloc] initWithService:self
                                                             mode:kMFWebRequestModeJsonPost
                                                           target:target
                                                             path:@"/user/details"
                                                       parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  identifier, @"id", nil]];
    
    request.block = block;
    request.transform = [MFUserDetails class];
    [self addRequest:request];
}

- (void)requestUserEdit:(MFUserDetails *)user target:(id)target usingBlock:(MFWebRequestBlock)block
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    MFWebRequest *request;
    
    [parameters setValue:user.sizeId forKey:@"size"];
    [parameters setValue:user.mediaId forKey:@"media"];
    [parameters setValue:user.email forKey:@"email"];
    [parameters setValue:user.phone forKey:@"phone"];
    [parameters setValue:user.firstName forKey:@"first_name"];
    [parameters setValue:user.lastName forKey:@"last_name"];
    [parameters setValue:user.countryId forKey:@"country"];
    [parameters setValue:user.city forKey:@"city"];
    [parameters setValue:user.address forKey:@"address"];
    [parameters setValue:user.zipcode forKey:@"zipcode"];
    
    request = [[MFWebRequest alloc] initWithService:self
                                               mode:kMFWebRequestModeJsonPost
                                             target:target
                                               path:@"/user/edit"
                                         parameters:parameters];
    request.block = block;
    [self addRequest:request];
}

@end
