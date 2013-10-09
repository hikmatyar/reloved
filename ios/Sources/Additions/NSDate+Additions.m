/* Copyright (c) 2013 Meep Factory OU */

#import "NSDate+Additions.h"

@implementation NSDate(Additions)

@dynamic datetimeString;

- (NSString *)datetimeString
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
	
	return [datetimeFormatter stringFromDate:self];
}

@end
