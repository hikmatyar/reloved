/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequest.h"
#import "MFWebService.h"

@class MFCart;

@interface MFWebService(Checkout)

- (void)requestCheckout:(NSArray *)postIds lastModification:(NSDate *)lastModification target:(id)target usingBlock:(MFWebRequestBlock)block;
- (void)requestOrderCreate:(MFCart *)cart target:(id)target usingBlock:(MFWebRequestBlock)block;
- (void)requestOrderStatus:(NSString *)orderId target:(id)target usingBlock:(MFWebRequestBlock)block;

@end
