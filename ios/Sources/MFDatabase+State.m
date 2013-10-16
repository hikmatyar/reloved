/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase+State.h"
#import "SQLObjectStore.h"

#define KEY_PREFIX @"prefix"
#define KEY_STATE @"state"

@implementation MFDatabase(State)

- (void)attach_proxy_state
{
    [m_state setValue:[m_store propertyForKey:KEY_PREFIX] forKey:KEY_PREFIX];
    [m_state setValue:[m_store propertyForKey:KEY_STATE] forKey:KEY_STATE];
}

@dynamic globalPrefix;

- (NSURL *)globalPrefix
{
    return [m_state objectForKey:KEY_PREFIX];
}

- (void)setGlobalPrefix:(NSURL *)globalPrefix
{
    NSURL *s_globalState = [m_state objectForKey:KEY_PREFIX];
    
    if(!MFEqual(s_globalState, globalPrefix)) {
        [m_state setValue:globalPrefix forKey:KEY_PREFIX];
        [m_store setProperty:globalPrefix forKey:KEY_PREFIX];
    }
}

@dynamic globalState;

- (NSString *)globalState
{
    return [m_state objectForKey:KEY_STATE];
}

- (void)setGlobalState:(NSString *)globalState
{
    NSString *s_globalState = [m_state objectForKey:KEY_STATE];
    
    if(!MFEqual(s_globalState, globalState)) {
        [m_state setValue:globalState forKey:KEY_STATE];
        [m_store setProperty:globalState forKey:KEY_STATE];
    }
}

- (NSURL *)URLForMedia:(NSString *)mediaId size:(MFMediaSize)size
{
    if(mediaId) {
        BOOL retina = ([UIScreen mainScreen].scale > 1.5F) ? YES : NO;
        NSURL *prefix = [m_state objectForKey:KEY_PREFIX];
        
        if(!prefix) {
            prefix = [NSURL URLWithString:@"http://api.relovedapp.co.uk/media/download/"];
        }
        
        switch(size) {
            case kMFMediaSizeOriginal:
                // Do nothing
                break;
            case kMFMediaSizeThumbnailSmall:
                mediaId = [mediaId stringByAppendingString:(retina) ? @"?size=t2" : @"?size=t1"];
                break;
            case kMFMediaSizeThumbnailLarge:
                mediaId = [mediaId stringByAppendingString:(retina) ? @"?size=t4" : @"?size=t3"];
                break;
            case kMFMediaSizePhoto:
                if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                    mediaId = [mediaId stringByAppendingString:(retina) ? @"?size=i4" : @"?size=i3"];
                } else {
                    mediaId = [mediaId stringByAppendingString:(retina) ? @"?size=i2" : @"?size=i1"];
                }
                break;
        }
        
        return ((NSURL *)[NSURL URLWithString:mediaId relativeToURL:prefix]).absoluteURL;
    }
    
    return nil;
}

- (NSURL *)URLForString:(NSString *)str
{
    return (str) ? ((NSURL *)[NSURL URLWithString:str relativeToURL:[m_state objectForKey:KEY_PREFIX]]).absoluteURL : nil;
}

@end
