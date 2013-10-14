/* Copyright (c) 2013 Meep Factory OU */

#import <CommonCrypto/CommonHMAC.h>
#import "NSString+Additions.h"

@implementation NSString(Additions)

@dynamic dateValue;

- (NSDate *)dateValue
{
    __strong static NSDateFormatter *dateFormatter = nil;
	static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    
	return [dateFormatter dateFromString:self];
}

@dynamic datetimeValue;

- (NSDate *)datetimeValue
{
    __strong static NSDateFormatter *datetimeFormatter = nil;
	static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        datetimeFormatter = [[NSDateFormatter alloc] init];
		datetimeFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        datetimeFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        datetimeFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        datetimeFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
	});
	
	return [datetimeFormatter dateFromString:self];
}

@dynamic sha1Value;

- (NSString *)sha1Value
{
	NSMutableString *hexString = [NSMutableString string];
	const char *sourceString = self.UTF8String;
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	
	CC_SHA1(sourceString, strlen(sourceString), result);
	
	for(int i = 0; i < 20; i++) {
		[hexString appendFormat:@"%02x", result[i]];
	}
	
	return hexString;
}

@dynamic stringByTrimmingWhitespace;

- (NSString *)stringByTrimmingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@dynamic allTags;

- (NSArray *)allTags
{
    NSCharacterSet *chars = [NSCharacterSet alphanumericCharacterSet];
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    NSMutableSet *tags = nil;
    
    while(!scanner.isAtEnd) {
        if([scanner scanUpToString:@"#" intoString:nil] && [scanner scanString:@"#" intoString:nil]) {
            NSString *tag = nil;
            
            if([scanner scanCharactersFromSet:chars intoString:&tag] && tag.length > 2) {
                if(!tags) {
                    tags = [NSMutableSet set];
                }
                
                [tags addObject:tag.lowercaseString];
            }
        } else {
            break;
        }
    }
    
    return tags.allObjects;
}

@end
