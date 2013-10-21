/* Copyright (c) 2013 Meep Factory OU */

#import "MFBrand.h"
#import "MFColor.h"
#import "MFCondition.h"
#import "MFDatabase+Bookmark.h"
#import "MFDatabase+Brand.h"
#import "MFDatabase+Color.h"
#import "MFDatabase+Size.h"
#import "MFDatabase+Type.h"
#import "MFPost.h"
#import "MFPostDetails.h"
#import "MFSize.h"
#import "MFType.h"
#import "MFWebPost.h"
#import "MFWebService+Post.h"
#import "MFWebSession.h"

NSString *MFWebPostChangesKey = @"changes";
NSString *MFWebPostErrorKey = @"error";

NSString *MFWebPostDidBeginLoadingNotification = @"MFWebPostDidBeginLoading";
NSString *MFWebPostDidEndLoadingNotification = @"MFWebPostDidEndLoading";
NSString *MFWebPostDidChangeNotification = @"MFWebPostDidChange";
NSString *MFWebPostDidDeleteNotification = @"MFWebPostDidDelete";

#define LOADING_LIMIT 100

static inline NSDictionary *MFWebPostGetUserInfo(NSArray *changes, NSError *error) {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    
    [userInfo setValue:error forKey:MFWebPostErrorKey];
    [userInfo setValue:changes forKey:MFWebPostChangesKey];
    
    return userInfo;
}

#pragma mark -

@implementation MFWebPost

- (id)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    
    if(self) {
        m_identifier = identifier;
    }
    
    return self;
}

- (id)initWithPost:(MFPost *)post
{
    self = [self initWithIdentifier:post.identifier];
    
    if(self) {
        m_post = post;
    }
    
    return self;
}

@synthesize post = m_post;
@synthesize loading = m_loading;
@synthesize comments = m_comments;

@dynamic brand;

- (MFBrand *)brand
{
    return [[MFDatabase sharedDatabase] brandForIdentifier:m_post.brandId];
}

@dynamic colors;

- (NSArray *)colors
{
    return [[MFDatabase sharedDatabase] colorsForIdentifiers:m_post.colorIds];
}

@dynamic condition;

- (MFCondition *)condition
{
    NSString *identifier = m_post.conditionId;
    
    for(MFCondition *condition in [MFCondition allConditions]) {
        if([identifier isEqualToString:condition.identifier]) {
            return condition;
        }
    }
    
    return nil;
}

@dynamic size;

- (MFSize *)size
{
    return [[MFDatabase sharedDatabase] sizeForIdentifier:m_post.sizeId];
}

@dynamic types;

- (NSArray *)types
{
    return [[MFDatabase sharedDatabase] typesForIdentifiers:m_post.typeIds];
}

@dynamic loaded;

- (BOOL)isLoaded
{
    return (m_post) ? YES : NO;
}

@dynamic mine;

- (BOOL)isMine
{
    return (m_post) ? [[MFWebService sharedService].session.userId isEqualToString:m_post.userId] : NO;
}

@dynamic saved;

- (BOOL)isSaved
{
    return [[MFDatabase sharedDatabase] isBookmarkedForPost:m_post];
}

- (void)setSaved:(BOOL)saved
{
    [[MFDatabase sharedDatabase] setBookmarked:saved forPost:m_post];
}

@dynamic insideCart;

- (BOOL)insideCart
{
    // TODO:
    
    return NO;
}

- (void)setInsideCart:(BOOL)insideCart
{
    // TODO:
}

- (void)startLoading
{
    if(!m_loading) {
        m_loading = YES;
        
        [[MFWebService sharedService] requestPostDetails:m_identifier state:m_state limit:LOADING_LIMIT target:self usingBlock:^(id target, NSError *error, MFPostDetails *details) {
            m_loading = NO;
            
            if(!error && details) {
                if(!m_post) {
                    m_post = details.post;
                }
                
                if(details.comments) {
                    m_comments = details.comments;
                }
                
                if(details.state) {
                    m_state = details.state;
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:MFWebPostDidChangeNotification object:self userInfo:MFWebPostGetUserInfo(nil, nil)];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MFWebPostDidEndLoadingNotification object:self userInfo:MFWebPostGetUserInfo(nil, error)];
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MFWebPostDidBeginLoadingNotification object:self];
    }
}

- (void)stopLoading
{
    if(m_loading) {
        [[MFWebService sharedService] cancelRequestsForTarget:self];
        m_loading = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:MFWebPostDidEndLoadingNotification object:self userInfo:MFWebPostGetUserInfo(nil, nil)];
    }
}

- (void)reloadData
{
    [self stopLoading];
    [self startLoading];
}

- (void)delete
{
    MFMutablePost *post = [[MFMutablePost alloc] init];
    
    post.identifier = m_identifier;
    post.status = kMFPostStatusUnlisted;
    
    [[MFWebService sharedService] requestPostEdit:post changes:kMFPostChangeStatus target:self usingBlock:^(id target, NSError *error, id result) {
        if(!error) {
            m_post = nil;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MFWebPostDidDeleteNotification object:self userInfo:MFWebPostGetUserInfo(nil, error)];
    }];
}

@end
