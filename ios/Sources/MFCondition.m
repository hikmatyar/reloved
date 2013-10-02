/* Copyright (c) 2013 Meep Factory OU */

#import "MFCondition.h"

@implementation MFCondition

+ (NSArray *)allConditions
{
    __strong static NSArray *allConditions = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        allConditions = [[NSArray alloc] initWithObjects:
            [[MFCondition alloc] initWithIdentifier:@"1" title:NSLocalizedString(@"Condition.1.Title", nil) comments:
                [NSArray arrayWithObjects:NSLocalizedString(@"Condition.1.Comment1", nil), NSLocalizedString(@"Condition.1.Comment2", nil), NSLocalizedString(@"Condition.1.Comment3", nil), nil]],
            [[MFCondition alloc] initWithIdentifier:@"2" title:NSLocalizedString(@"Condition.2.Title", nil) comments:
                [NSArray arrayWithObjects:NSLocalizedString(@"Condition.2.Comment1", nil), NSLocalizedString(@"Condition.2.Comment2", nil), NSLocalizedString(@"Condition.2.Comment3", nil), nil]],
            [[MFCondition alloc] initWithIdentifier:@"3" title:NSLocalizedString(@"Condition.3.Title", nil) comments:
                [NSArray arrayWithObjects:NSLocalizedString(@"Condition.3.Comment1", nil), NSLocalizedString(@"Condition.3.Comment2", nil), NSLocalizedString(@"Condition.3.Comment3", nil), nil]], nil];
    });
    
    return allConditions;
}

- (id)initWithIdentifier:(NSString *)identifier title:(NSString *)title comments:(NSArray *)comments
{
    self = [super init];
    
    if(self) {
        m_identifier = identifier;
        m_title = title;
        m_comments = comments;
    }
    
    return self;
}

@synthesize identifier = m_identifier;
@synthesize title = m_title;
@synthesize comments = m_comments;

@end
