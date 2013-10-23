/* Copyright (c) 2013 Meep Factory OU */

#import "MFNotice.h"
#import "NSDictionary+Additions.h"

#define KEY_TITLE @"title"
#define KEY_SUBJECT @"subject"
#define KEY_MESSAGE @"message"

@implementation MFNotice

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        m_title = [attributes stringForKey:KEY_TITLE];
        m_subject = [attributes stringForKey:KEY_SUBJECT];
        m_message = [attributes stringForKey:KEY_MESSAGE];
        
        if(!m_message) {
            return nil;
        }
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setValue:m_title forKey:KEY_TITLE];
    [attributes setValue:m_subject forKey:KEY_SUBJECT];
    [attributes setValue:m_message forKey:KEY_MESSAGE];
    
    return attributes;
}

@synthesize title = m_title;
@synthesize subject = m_subject;
@synthesize message = m_message;

@end
