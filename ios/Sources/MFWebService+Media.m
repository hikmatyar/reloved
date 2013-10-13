/* Copyright (c) 2013 Meep Factory OU */

#import "MFMedia.h"
#import "MFWebRequestTransform.h"
#import "MFWebService+Media.h"
#import "NSDictionary+Additions.h"

@interface MFWebService_Media : NSObject <MFWebRequestTransform>

@end

@implementation MFWebService_Media

#pragma mark MFWebRequestTransform

+ (id)parseFromObject:(id)object
{
    return ([object isKindOfClass:[NSDictionary class]]) ? [(NSDictionary *)object identifierForKey:@"id"] : nil;
}

@end

#pragma mark -

@implementation MFWebService(Media)

- (void)requestMediaIdentifier:(NSString *)csum size:(UInt64)size target:(id)target usingBlock:(MFWebRequestBlock)block
{
    MFWebRequest *request = [[MFWebRequest alloc] initWithService:self
                                                             mode:kMFWebRequestModeJsonPost
                                                           target:target
                                                             path:@"/media/create"
                                                       parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [NSNumber numberWithLong:size], @"size",
                                                                  @"image/jpeg", @"mime",
                                                                  csum, @"csum", nil]];
    
    request.block = block;
    request.transform = [MFWebService_Media class];
    [self addRequest:request];
}

- (void)requestMediaUpload:(NSString *)path identifier:(NSString *)identifier target:(id)target usingBlock:(MFWebRequestBlock)block
{
    MFWebRequest *request = [[MFWebRequest alloc] initWithService:self
                                                             mode:kMFWebRequestModeJsonPost
                                                           target:target
                                                             path:@"/media/upload"
                                                       parameters:[NSDictionary dictionaryWithObjectsAndKeys:identifier, @"id", nil]];
    
    [request setFile:path forKey:@"data"];
    request.block = block;
    request.shouldContinueWhenAppEntersBackground = YES;
    request.transform = [MFMedia class];
    [self addRequest:request];
}

@end
