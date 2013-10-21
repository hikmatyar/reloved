/* Copyright (c) 2013 Meep Factory OU */

#import "MFDatabase.h"

@class MFPost;

extern NSString *MFDatabaseDidChangeCartNotification;

@interface MFDatabase(Cart)

@property (nonatomic, copy) NSArray *cart;

- (BOOL)includedInCartForPost:(MFPost *)post;
- (void)includeInCart:(BOOL)included forPost:(MFPost *)post;

@end
