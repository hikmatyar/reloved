/* Copyright (c) 2013 Meep Factory OU */

#import "NSArray+Additions.h"
#import "MFDelta.h"

@implementation NSArray(Additions)

- (NSArray *)deltaWithArray:(NSArray *)array changes:(NSSet *)changes
{
    NSMutableArray *delta = [[NSMutableArray alloc] init];
    NSMutableArray *state = [[NSMutableArray alloc] initWithArray:self];
    
    // Update rows 0...N
    if(changes.count > 0) {
        for(NSObject *item in array) {
            NSInteger index = [self indexOfObject:item];
            
            if(index != NSNotFound && [changes containsObject:item]) {
                [delta addObject:[[MFDelta alloc] initWithOp:kMFDeltaOpUpdate index1:index index2:index]];
            }
        }
    }
    
    // Delete rows N...0
    for(NSObject *item in self.reverseObjectEnumerator) {
        if(![array containsObject:item]) {
            NSInteger index = [self indexOfObject:item];
            
            [delta addObject:[[MFDelta alloc] initWithOp:kMFDeltaOpDelete index1:index index2:index]];
            [state removeObject:item];
        }
    }
    
    // Insert or move rows 0...N
    for(NSObject *item in array) {
        NSInteger index1 = [state indexOfObject:item];
        NSInteger index2 = [array indexOfObject:item];
        
        // Insert
        if(index1 == NSNotFound) {
            [delta addObject:[[MFDelta alloc] initWithOp:kMFDeltaOpInsert index1:index2 index2:index2]];
            [state insertObject:item atIndex:index2];
        // Move!
        } else if(index1 != index2) {
            index1 = [self indexOfObject:item];
            [delta addObject:[[MFDelta alloc] initWithOp:kMFDeltaOpMove index1:index1 index2:index2]];
        }
    }
    
    return delta;

}

@end
