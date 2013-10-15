/* Copyright (c) 2013 Meep Factory OU */

#import <CommonCrypto/CommonDigest.h>
#import "NSData+Additions.h"
#import "base64.h"

@implementation NSData(Additions)

- (id)initWithBase64String:(NSString *)base64String
{
    const char *utf8 = base64String.UTF8String;
    size_t utf8_length = strlen(utf8);
    char src[utf8_length + 1];
    size_t buffer_size = utf8_length;
    u_char *buffer = (u_char *)malloc(sizeof(u_char) * buffer_size);
    int length;
    
    memcpy(&(src[0]), utf8, utf8_length + 1);
    
    if((length = b64_pton(src, buffer, buffer_size)) == -1) {
        free(buffer);
        return nil;
    }
    
    return [self initWithBytesNoCopy:buffer length:length freeWhenDone:YES];
}

- (id)initWithBase64SafeString:(NSString *)base64SafeString
{
    const char *utf8 = base64SafeString.UTF8String;
    size_t utf8_length = strlen(utf8);
    char src[utf8_length + 1];
    size_t buffer_size = utf8_length;
    u_char *buffer = (u_char *)malloc(sizeof(u_char) * buffer_size);
    int index, length;
    
    memcpy(&(src[0]), utf8, utf8_length + 1);
    
    for(index = 0; index < buffer_size; index++) {
        if(src[index] == '-') {
            src[index] = '+';
        } else if(src[index] == '_') {
            src[index] = '/';
        }
    }
    
    if((length = b64_pton(src, buffer, buffer_size)) == -1) {
        free(buffer);
        return nil;
    }
    
    return [self initWithBytesNoCopy:buffer length:length freeWhenDone:YES];
}

@dynamic base64String;

- (NSString *)base64String
{
    size_t buffer_size = (self.length * 3 + 2) / 2;
    char *buffer = (char *)malloc(sizeof(char) * buffer_size);
    int length;
    
    if((length = b64_ntop(self.bytes, self.length, buffer, buffer_size)) == -1) {
        free(buffer);
        return nil;
    }
    
    return [[NSString alloc] initWithBytesNoCopy:buffer length:length encoding:NSUTF8StringEncoding freeWhenDone:YES];
}

@dynamic base64SafeString;

- (NSString *)base64SafeString
{
    size_t buffer_size = (self.length * 3 + 2) / 2;
    char *buffer = (char *)malloc(sizeof(char) * buffer_size);
    int index, length;
    
    if((length = b64_ntop(self.bytes, self.length, buffer, buffer_size)) == -1) {
        free(buffer);
        return nil;
    }
    
    for(index = 0; index < length; index++) {
        if(buffer[index] == '/') {
            buffer[index] = '_';
        } else if(buffer[index] == '+') {
            buffer[index] = '-';
        }
    }
    
    return [[NSString alloc] initWithBytesNoCopy:buffer length:length encoding:NSUTF8StringEncoding freeWhenDone:YES];
}

@dynamic md5String;

- (NSString *)md5String
{
    NSMutableString *md5 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    UInt8 buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(self.bytes, self.length, &(buffer[0]));
    
    for(NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5 appendFormat:@"%02x", buffer[i]];
    }
    
    return md5;
}

@end
