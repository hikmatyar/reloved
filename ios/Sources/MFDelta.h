/* Copyright (c) 2013 Meep Factory OU */

#import <Foundation/Foundation.h>

typedef enum _MFDeltaOp {
    kMFDeltaOpInsert = 0,
    kMFDeltaOpUpdate,
    kMFDeltaOpDelete,
    kMFDeltaOpMove
} MFDeltaOp;

@interface MFDelta : NSObject
{
    @private
    MFDeltaOp m_op;
    NSInteger m_index1;
    NSInteger m_index2;
}

- (id)initWithOp:(MFDeltaOp)op index1:(NSInteger)index1 index2:(NSInteger)index2;

@property (nonatomic, assign, readonly) MFDeltaOp op;
@property (nonatomic, assign, readonly) NSInteger index1;
@property (nonatomic, assign, readonly) NSInteger index2;

@end
