/* Copyright (c) 2013 Meep Factory OU */

#import "NSFileManager+Additions.h"

@implementation NSFileManager(Additions)

- (NSString *)pathForTemporaryFile
{
    return [self pathForTemporaryFileWithPrefix:nil];
}

- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    NSString *result = [NSTemporaryDirectory() stringByAppendingPathComponent:(prefix) ? [NSString stringWithFormat:@"%@-%@", prefix, uuidStr] : [NSString stringWithFormat:@"%@", uuidStr]];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

@end
