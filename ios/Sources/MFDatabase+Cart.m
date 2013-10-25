/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase+Cart.h"
#import "MFDatabase+Feed.h"
#import "MFDatabase+Post.h"
#import "MFPost.h"
#import "MFPreferences.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangeCartNotification = @"MFDatabaseDidChangeCart";

@implementation MFDatabase(Cart)

@dynamic cart;

- (NSArray *)cart
{
    return [self postsForFeed:[self.class feedIdentifierCart]];
}

- (void)setCart:(NSArray *)cart
{
    if(cart.count > 0) {
        NSMutableArray *cartIds = [NSMutableArray array];
        
        for(MFPost *post in cart) {
            [cartIds addObject:post.identifier];
        }
        
        [cartIds sortUsingSelector:@selector(compare:)];
        
        [self setPosts:cart forFeed:[self.class feedIdentifierCart]];
        [MFPreferences sharedPreferences].cart = cartIds;
    } else {
        [self setPosts:nil forFeed:[self.class feedIdentifierCart]];
        [MFPreferences sharedPreferences].cart = nil;
    }
    
    [self addUpdate:MFDatabaseDidChangeCartNotification change:nil];
}

- (BOOL)includedInCartForPost:(MFPost *)post
{
    for(NSString *cart in [MFPreferences sharedPreferences].cart) {
        if([post.identifier isEqualToString:cart]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)includeInCart:(BOOL)included forPost:(MFPost *)post
{
    MFPreferences *preferences = [MFPreferences sharedPreferences];
    NSArray *cart = preferences.cart;
    
    if(included) {
        NSMutableArray *b;
        
        if([cart containsObject:post.identifier]) {
            return;
        }
        
        b = (cart) ? [[NSMutableArray alloc] initWithArray:cart] : [[NSMutableArray alloc] init];
        [b addObject:post.identifier];
        preferences.cart = b;
        [m_store associateKey:[self.class feedIdentifierCart] inTable:[self.class feedTableName] withKey:post.identifier inTable:[self.class postTableName]];
        [self addUpdate:MFDatabaseDidChangeCartNotification change:post.identifier];
    } else {
        NSMutableArray *b;
        
        if(![cart containsObject:post.identifier]) {
            return;
        }
        
        b = [[NSMutableArray alloc] initWithArray:cart];
        [b removeObject:post.identifier];
        preferences.cart = b;
        [m_store dissociateKey:[self.class feedIdentifierCart] inTable:[self.class feedTableName] withKey:post.identifier inTable:[self.class postTableName]];
        [self addUpdate:MFDatabaseDidChangeCartNotification change:post.identifier];
    }
}

@end
