/* Copyright (c) 2013 Meep Factory OU */

#import "MFComment.h"
#import "MFPost.h"
#import "MFPostDetails.h"
#import "MFUser.h"
#import "NSDictionary+Additions.h"

#define KEY_COMMENTS @"comments"
#define KEY_POST @"post"
#define KEY_STATE @"state"
#define KEY_USERS @"users"

@implementation MFPostDetails

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if(self) {
        Class klass = [NSDictionary class];
        NSDictionary *dict;
        NSArray *arr;
        
        m_state = [attributes stringForKey:KEY_STATE];
        
        if((dict = [attributes dictionaryForKey:KEY_POST]) != nil) {
            m_post = [[MFPost alloc] initWithAttributes:dict];
        }
        
        if((arr = [attributes arrayForKey:KEY_COMMENTS]) != nil) {
            NSMutableArray *comments = [[NSMutableArray alloc] init];
            
            for(NSDictionary *attributes_ in arr) {
                if([attributes_ isKindOfClass:klass]) {
                    MFComment *comment = [[MFComment alloc] initWithAttributes:attributes_];
                    
                    if(comment) {
                        [comments addObject:comment];
                    }
                }
            }
            
            m_comments = comments;
        }
        
        if((arr = [attributes arrayForKey:KEY_USERS]) != nil) {
            NSMutableArray *users = [[NSMutableArray alloc] init];
            
            for(NSDictionary *attributes_ in arr) {
                if([attributes_ isKindOfClass:klass]) {
                    MFUser *user = [[MFUser alloc] initWithAttributes:attributes_];
                    
                    if(user) {
                        [users addObject:user];
                    }
                }
            }
            
            m_users = users;
        }
        
        if(!m_post) {
            return nil;
        }
    }
    
    return self;
}

@dynamic attributes;

- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setValue:m_state forKey:KEY_STATE];
    [attributes setValue:m_post.attributes forKey:KEY_POST];
    
    if(m_comments) {
        NSMutableArray *comments = [[NSMutableArray alloc] init];
        
        for(MFComment *comment in m_comments) {
            [comments addObject:comment.attributes];
        }
        
        [attributes setValue:comments forKey:KEY_COMMENTS];
    }
    
    if(m_users) {
        NSMutableArray *users = [[NSMutableArray alloc] init];
        
        for(MFUser *user in m_users) {
            [users addObject:user.attributes];
        }
        
        [attributes setValue:users forKey:KEY_USERS];
    }
    
    return attributes;
}

@dynamic author;

- (MFUser *)author
{
    NSString *identifier = m_post.userId;
    
    for(MFUser *user in m_users) {
        if([identifier isEqualToString:user.identifier]) {
            return user;
        }
    }
    
    return nil;
}

@synthesize comments = m_comments;
@synthesize post = m_post;
@synthesize users = m_users;
@synthesize state = m_state;

#pragma mark MFWebRequestTransform

+ (id)parseFromObject:(id)object
{
    return ([object isKindOfClass:[NSDictionary class]]) ? [[self alloc] initWithAttributes:(NSDictionary *)object] : nil;
}

@end
