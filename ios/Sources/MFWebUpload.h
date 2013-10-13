/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

extern NSString *MFWebUploadIdentifierKey;
extern NSString *MFWebUploadTicketKey;
extern NSString *MFWebUploadErrorKey;

extern NSString *MFWebUploadDidCompleteNotification;
extern NSString *MFWebUploadDidFailNotification;

@interface MFWebUpload : NSObject
{
    @private
    NSInteger m_counter;
    NSString *m_path;
    NSMutableSet *m_tickets;
    NSMutableArray *m_uploads;
}

+ (MFWebUpload *)sharedUpload;

- (NSString *)addImage:(UIImage *)image;
- (NSString *)addImageAtPath:(NSString *)path;
- (NSString *)replaceImage:(UIImage *)image;
- (NSString *)replaceImageAtPath:(NSString *)path;

- (void)invalidate;
- (void)clear:(NSString *)ticket;
- (void)clear;

@end
