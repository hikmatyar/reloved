/* Copyright (c) 2013 Meep Factory OU */

#import "MFCart.h"
#import "MFCheckout.h"
#import "MFOrder.h"
#import "MFWebService+Checkout.h"
#import "NSDate+Additions.h"

@implementation MFWebService(Checkout)

- (void)requestCheckout:(NSArray *)postIds lastModification:(NSDate *)lastModification target:(id)target usingBlock:(MFWebRequestBlock)block
{
    MFWebRequest *request = [[MFWebRequest alloc] initWithService:self
                                                             mode:kMFWebRequestModeJsonPost
                                                           target:target
                                                             path:@"/checkout"
                                                       parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  postIds, @"ids",
                                                                  (lastModification) ? lastModification.datetimeString : [NSNull null], @"mod", nil]];
    
    request.block = block;
    request.transform = [MFCheckout class];
    [self addRequest:request];
}

- (void)requestOrderCreate:(MFCart *)cart target:(id)target usingBlock:(MFWebRequestBlock)block
{
    MFWebRequest *request = [[MFWebRequest alloc] initWithService:self
                                                             mode:kMFWebRequestModeJsonPost
                                                           target:target
                                                             path:@"/order/create"
                                                       parameters:cart.attributes];
    
    request.block = block;
    request.transform = [MFOrder class];
    [self addRequest:request];
}

- (void)requestOrderStatus:(NSString *)orderId target:(id)target usingBlock:(MFWebRequestBlock)block
{
    MFWebRequest *request = [[MFWebRequest alloc] initWithService:self
                                                             mode:kMFWebRequestModeJsonPost
                                                           target:target
                                                             path:@"/order/status"
                                                       parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  orderId, @"id", nil]];
    
    request.block = block;
    request.transform = [MFOrder class];
    [self addRequest:request];
}

@end
