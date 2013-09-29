/* Copyright (c) 2013 Meep Factory OU */

#import "MFDelta.h"

@implementation MFDelta

- (id)initWithOp:(MFDeltaOp)op index1:(NSInteger)index1 index2:(NSInteger)index2
{
    self = [super init];
    
    if(self) {
        m_op = op;
        m_index1 = index1;
        m_index2 = index2;
    }
    
    return self;
}

@synthesize op = m_op;
@synthesize index1 = m_index1;
@synthesize index2 = m_index2;

#pragma mark NSObject

- (BOOL)isEqual:(MFDelta *)object
{
    return (self == object || (m_op == object.op && m_index1 == object.index1 && m_index2 == object.index2)) ? YES : NO;
}

- (NSString *)description
{
    return (m_op == kMFDeltaOpMove) ?
        [NSString stringWithFormat:@"MOVE %d -> %d", m_index1, m_index2] :
        [NSString stringWithFormat:@"%@ %d",
            ((m_op == kMFDeltaOpDelete) ? @"DELETE" :
             ((m_op == kMFDeltaOpUpdate) ? @"UPDATE" :
              ((m_op == kMFDeltaOpInsert) ? @"INSERT" : @"MOVE"))), m_index1];
}

@end