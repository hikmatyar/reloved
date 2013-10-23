/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface MFCart : NSObject
{
    @protected
    NSArray *m_postIds;
}

@property (nonatomic, retain, readonly) NSDictionary *attributes;

@property (nonatomic, retain, readonly) NSArray *postIds;

@end

@interface MFMutableCart : MFCart

@property (nonatomic, retain) NSArray *postIds;

@end