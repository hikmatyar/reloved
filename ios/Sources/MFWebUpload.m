/* Copyright (c) 2013 Meep Factory OU */

#import "MFMedia.h"
#import "MFWebUpload.h"
#import "MFWebService+Media.h"
#import "NSData+Additions.h"
#import "NSFileManager+Additions.h"

@interface MFWebUpload_Item : NSObject
{
    @private
    UInt64 m_fileSize;
    NSString *m_identifier;
    NSString *m_path;
    BOOL m_inProgress;
    NSString *m_ticket;
}

- (id)initWithIdentifier:(NSString *)identifier ticket:(NSString *)ticket fileSize:(UInt64)fileSize path:(NSString *)path;

@property (nonatomic, assign, readonly) UInt64 fileSize;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, assign) BOOL inProgress;
@property (nonatomic, retain, readonly) NSString *ticket;

@end

@implementation MFWebUpload_Item

- (id)initWithIdentifier:(NSString *)identifier ticket:(NSString *)ticket fileSize:(UInt64)fileSize path:(NSString *)path
{
    self = [super init];
    
    if(self) {
        m_identifier = identifier;
        m_path = path;
        m_ticket = ticket;
        m_fileSize = fileSize;
    }
    
    return self;
}

@synthesize fileSize = m_fileSize;
@synthesize identifier = m_identifier;
@synthesize path = m_path;
@synthesize inProgress = m_inProgress;
@synthesize ticket = m_ticket;

@end

#pragma mark -

NSString *MFWebUploadIdentifierKey = @"id";
NSString *MFWebUploadTicketKey = @"ticket";
NSString *MFWebUploadErrorKey = @"error";

NSString *MFWebUploadDidCompleteNotification = @"MFWebUploadDidComplete";
NSString *MFWebUploadDidFailNotification = @"MFWebUploadDidFail";

#define PLACEHOLDER @"Z"

@implementation MFWebUpload

+ (MFWebUpload *)sharedUpload
{
    __strong static MFWebUpload *sharedUpload = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        sharedUpload = [[self alloc] init];
    });
    
    return sharedUpload;
}

- (NSString *)generateTicket
{
    NSString *ticket = nil;
    
    while(!ticket || [m_tickets containsObject:ticket]) {
        if(m_counter > 1000000) {
            m_counter = 0;
        }
        
        m_counter += 1;
        ticket = [NSString stringWithFormat:@"%d", m_counter];
    }
    
    return ticket;
}

- (void)invalidate:(MFWebUpload_Item *)upload csum:(NSString *)csum
{
    if(!upload.inProgress) {
        upload.inProgress = YES;
        
        if([upload.identifier isEqualToString:PLACEHOLDER]) {
            [[MFWebService sharedService] requestMediaIdentifier:(csum) ? csum : [[NSFileManager defaultManager] md5ForFileAtPath:upload.path]
                                                            size:upload.fileSize
                                                          target:upload
                                                      usingBlock:^(id target, NSError *error, NSString *identifier) {
                upload.inProgress = NO;
                
                if(identifier) {
                    NSString *path = [m_path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", identifier, upload.ticket]];
                    
                    [[NSFileManager defaultManager] moveItemAtPath:upload.path toPath:path error:nil];
                    
                    upload.identifier = identifier;
                    upload.path = path;
                    
                    [self invalidate:upload csum:nil];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:MFWebUploadDidFailNotification
                                                                        object:self
                                                                      userInfo:[NSDictionary dictionaryWithObject:upload.ticket forKey:MFWebUploadTicketKey]];
                }
            }];
        } else {
            [[MFWebService sharedService] requestMediaUpload:upload.path identifier:upload.identifier target:upload usingBlock:^(id target, NSError *error, MFMedia *media) {
                upload.inProgress = NO;
                
                if(error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:MFWebUploadDidFailNotification
                                                                        object:self
                                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                upload.ticket, MFWebUploadTicketKey,
                                                                                upload.identifier, MFWebUploadIdentifierKey, nil]];
                } else {
                    [m_tickets removeObject:upload.ticket];
                    [m_uploads removeObjectIdenticalTo:upload];
                    [[NSFileManager defaultManager] removeItemAtPath:upload.path error:nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:MFWebUploadDidCompleteNotification
                                                                        object:self
                                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                upload.ticket, MFWebUploadTicketKey,
                                                                                upload.identifier, MFWebUploadIdentifierKey, nil]];
                }
            }];
        }
    }
}

- (void)invalidate
{
    for(MFWebUpload_Item *upload in m_uploads) {
        [self invalidate:upload csum:nil];
    }
}

- (NSString *)addImage:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    if(data) {
        NSString *ticket = [self generateTicket];
        NSString *path = [m_path stringByAppendingPathComponent:[NSString stringWithFormat:PLACEHOLDER @".%@", ticket]];
        MFWebUpload_Item *upload = [[MFWebUpload_Item alloc] initWithIdentifier:PLACEHOLDER ticket:ticket fileSize:data.length path:path];
        
        if([data writeToFile:path atomically:YES]) {
            [m_tickets addObject:ticket];
            [m_uploads addObject:upload];
            
            [self invalidate:upload csum:data.md5String];
            
            return ticket;
        }
    }
    
    return nil;
}

- (NSString *)addImageAtPath:(NSString *)path
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    if(data) {
        NSString *ticket = [self generateTicket];
        NSString *path = [m_path stringByAppendingPathComponent:[NSString stringWithFormat:PLACEHOLDER @".%@", ticket]];
        MFWebUpload_Item *upload = [[MFWebUpload_Item alloc] initWithIdentifier:PLACEHOLDER ticket:ticket fileSize:data.length path:path];
        
        if([data writeToFile:path atomically:YES]) {
            [m_tickets addObject:ticket];
            [m_uploads addObject:upload];
            
            [self invalidate:upload csum:data.md5String];
            
            return ticket;
        }
    }
    
    return nil;
}

- (NSString *)replaceImage:(UIImage *)image
{
    [self clear];
    
    return [self addImage:image];
}

- (NSString *)replaceImageAtPath:(NSString *)path
{
    [self clear];
    
    return [self addImageAtPath:path];
}

- (void)clear:(NSString *)ticket
{
    MFWebUpload_Item *upload = nil;
    
    for(MFWebUpload_Item *upload_ in m_uploads) {
        if([ticket isEqualToString:upload.ticket]) {
            upload = upload_;
            break;
        }
    }
    
    if(upload) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        MFWebService *webService = [MFWebService sharedService];
        
        MFDebug(@"%@", upload.identifier);
        
        if(upload.inProgress) {
            [webService cancelRequestsForTarget:upload waitUntilFinished:YES];
        }
        
        [fileManager removeItemAtPath:upload.path error:nil];
        [m_tickets removeObject:upload.ticket];
        [m_uploads removeObjectIdenticalTo:upload];
    }
}

- (void)clear
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    MFWebService *webService = [MFWebService sharedService];
    
    for(MFWebUpload_Item *upload in m_uploads) {
        MFDebug(@"%@", upload.identifier);
        
        if(upload.inProgress) {
            [webService cancelRequestsForTarget:upload waitUntilFinished:YES];
        }
        
        [fileManager removeItemAtPath:upload.path error:nil];
    }
    
    [m_uploads removeAllObjects];
    [m_tickets removeAllObjects];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    
    if(self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *enumerator;
        NSString *path;
        
        m_path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"uploads"];
        m_uploads = [[NSMutableArray alloc] init];
        
        if(![fileManager fileExistsAtPath:m_path]) {
            [fileManager createDirectoryAtPath:m_path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        enumerator = [fileManager enumeratorAtPath:m_path];
        
        while((path = [enumerator nextObject]) != nil) {
            NSArray *cmp = [path componentsSeparatedByString:@"."];
            
            if(cmp.count == 2) {
                NSString *rpath = [m_path stringByAppendingPathComponent:path];
                MFWebUpload_Item *upload = [[MFWebUpload_Item alloc] initWithIdentifier:[cmp objectAtIndex:0] ticket:[cmp objectAtIndex:1] fileSize:[fileManager sizeForFileAtPath:rpath] path:rpath];
                
                if(upload && ![m_tickets containsObject:upload.ticket]) {
                    [m_uploads addObject:upload];
                    [m_tickets addObject:upload.ticket];
                }
            } else {
                MFError(@"Invalid filename '%@'", path);
            }
        }
    }
    
    return self;
}

@end