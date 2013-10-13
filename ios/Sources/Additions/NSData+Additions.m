/* Copyright (c) 2013 Meep Factory OU */

#import <CommonCrypto/CommonDigest.h>
#import "NSData+Additions.h"

static const unsigned char kMFB64ETable[64] = {
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
    'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
    'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','-'
};

@implementation NSData(Additions)

- (id)initWithBase64String:(NSString *)base64
{
    const unsigned char *data = (const unsigned char *)base64.UTF8String;
    size_t dataSize = strlen((const char *)data);
    const unsigned char *end = data + dataSize;
    const unsigned char *ptr = data;
    unsigned char *decodedData = NULL;
    unsigned int decodedDataSize   = 0;
    unsigned int decodedDataLength = 0;
    int tmpIndex = 0;
    unsigned char tmp[4];
    
    if(!data || !dataSize) {
        return nil;
    }
    
    while(ptr < end) {
        unsigned char ch = *ptr++;
        int tmpCount = 3;
        
        if(ch >= 'A' && ch <= 'Z') ch = ch - 'A';
        else if(ch >= 'a' && ch <= 'z') ch = ch - 'a' + 26;
        else if(ch >= '0' && ch <= '9') ch = ch - '0' + 52;
        else if(ch == '+') ch = 62;
        else if(ch == '/') ch = 63;
        /* EOF marker */
        else if(ch == '=') {
            if(tmpIndex == 0) break;
            
            tmpCount = (tmpIndex == 1 || tmpIndex == 2) ? 1 : 2;
            tmpIndex = 3;
            ptr = end;
        }
        /* Unknown character (Probably white space) */
        else continue;
        
        tmp[tmpIndex] = ch;
        tmpIndex++;
        
        if(tmpIndex == 4) {
            tmpIndex = 0;
            
            if(decodedDataLength + 3 >= decodedDataSize) {
                decodedDataSize += decodedDataSize / 2 + 32;
                decodedData = realloc(decodedData, sizeof(unsigned char) * decodedDataSize);
            }
            
            switch(tmpCount) {
                case 3:
                    decodedData[decodedDataLength + 2] = ((tmp[2] & 0x03) << 6) | (tmp[3] & 0x3F);
                case 2:
                    decodedData[decodedDataLength + 1] = ((tmp[1] & 0x0F) << 4) | ((tmp[2] & 0x3C) >> 2);
                case 1:
                    decodedData[decodedDataLength + 0] = (tmp[0] << 2) | ((tmp[1] & 0x30) >> 4);
                    break;
                default:
                    // It should never get here
                    break;
            }
            
            decodedDataLength += tmpCount;
        }
    }
    
    return [self initWithBytesNoCopy:realloc(decodedData, sizeof(unsigned char) * decodedDataLength) length:decodedDataLength freeWhenDone:YES];
}

- (NSString *)base64String
{
    const unsigned char *data = self.bytes;
    size_t dataSize = self.length;
    unsigned char *encodedData = NULL;
    unsigned int encodedDataLength = 0;
    unsigned int encodedDataSize   = 0;
    const unsigned char *end = data + dataSize;
    const unsigned char *ptr = data;
    unsigned char tmp[3];
    
    while(ptr < end) {
        tmp[0] = (ptr + 0 < end) ? *(ptr + 0) : 0;
        tmp[1] = (ptr + 1 < end) ? *(ptr + 1) : 0;
        tmp[2] = (ptr + 2 < end) ? *(ptr + 2) : 0;
        
        if(encodedDataLength + 4 >= encodedDataSize) {
            encodedDataSize += encodedDataSize / 2 + 32;
            encodedData = realloc(encodedData, sizeof(unsigned char) * encodedDataSize);
        }
        
        encodedData[encodedDataLength + 0] = (tmp[0] & 0xFC) >> 2;
        encodedData[encodedDataLength + 1] = ((tmp[0] & 0x03) << 4) | ((tmp[1] & 0xF0) >> 4);
        encodedData[encodedDataLength + 2] = ((tmp[1] & 0x0F) << 2) | ((tmp[2] & 0xC0) >> 6);
        encodedData[encodedDataLength + 3] = tmp[2] & 0x3F;
        
        switch(end - ptr) {
            default:
                encodedData[encodedDataLength + 3] = kMFB64ETable[encodedData[encodedDataLength + 3]];
            case 2:
                encodedData[encodedDataLength + 2] = kMFB64ETable[encodedData[encodedDataLength + 2]];
            case 1:
                encodedData[encodedDataLength + 1] = kMFB64ETable[encodedData[encodedDataLength + 1]];
                encodedData[encodedDataLength + 0] = kMFB64ETable[encodedData[encodedDataLength + 0]];
                break;
        }
        
        switch(end - ptr) {
            case 1:
                encodedData[encodedDataLength + 2] = '=';
            case 2:
                encodedData[encodedDataLength + 3] = '=';
                break;
            default:
                break;
        }
        
        encodedDataLength += 4;
        ptr += 3;
    }
    
    return [[NSString alloc] initWithBytesNoCopy:realloc(encodedData, sizeof(unsigned char) * encodedDataLength) length:encodedDataLength encoding:NSUTF8StringEncoding freeWhenDone:YES];
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
