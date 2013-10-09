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

- (NSURL *)URLForString:(NSString *)str
{
    return (str) ? ((NSURL *)[NSURL URLWithString:str relativeToURL:[m_state objectForKey:KEY_PREFIX]]).absoluteURL : nil;
}

@end
