/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface NSFileManager(Additions)

- (NSString *)md5ForFileAtPath:(NSString *)path;
- (NSString *)pathForTemporaryFile;
- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix;
- (UInt64)sizeForFileAtPath:(NSString *)path;

@end
