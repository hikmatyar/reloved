/* Copyright (c) 2013 Meep Factory OU */

#import <sys/stat.h>
#import "NSData+Additions.h"
#import "NSFileManager+Additions.h"

@implementation NSFileManager(Additions)

- (NSString *)md5ForFileAtPath:(NSString *)path
{
    return ((NSData *)[NSData dataWithContentsOfFile:path]).md5String;
}

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

- (UInt64)sizeForFileAtPath:(NSString *)path
{
	if(path) {
		struct stat s;
		
		if(stat(path.fileSystemRepresentation, &s) == 0) {
			return s.st_size;
		}
	}
	
	return 0;
}

@end
