/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebRequestTransform.h"

typedef enum _MFMediaStatus {
    kMFMediaStatusInactive = 0,
    kMFMediaStatusUploading = 1,
    kMFMediaStatusUploaded = 2,
    kMFMediaStatusActive = 3,
    kMFMediaStatusInvalid = 4
} MFMediaStatus;

@interface MFMedia : NSObject <MFWebRequestTransform>
{
    @private
    NSString *m_identifier;
    MFMediaStatus m_status;
    NSInteger m_size;
}

- (id)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, assign, readonly) MFMediaStatus status;
@property (nonatomic, assign, readonly) NSInteger size;

@end
