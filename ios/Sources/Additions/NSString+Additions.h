/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface NSString(Additions)

@property (nonatomic, retain, readonly) NSDate *dateValue;
@property (nonatomic, retain, readonly) NSDate *datetimeValue;
@property (nonatomic, retain, readonly) NSString *sha1Value;
@property (nonatomic, retain, readonly) NSString *stringByReplacingSpecialHTMLCharacters;
@property (nonatomic, retain, readonly) NSString *stringByTrimmingWhitespace;
@property (nonatomic, retain, readonly) NSArray *allTags;

@end
