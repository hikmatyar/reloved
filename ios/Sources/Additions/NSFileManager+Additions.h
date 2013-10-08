/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

@interface NSFileManager(Additions)

- (NSString *)pathForTemporaryFile;
- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix;

@end
