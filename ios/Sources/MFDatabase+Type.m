/* Copyright (c) 2013 Meep Factory OU */

#import "JSONKit.h"
#import "MFDatabase+Type.h"
#import "MFType.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangeTypesNotification = @"MFDatabaseDidChangeTypes";

#define TABLE_TYPES @"types"

@implementation MFDatabase(Type)

@dynamic types;

- (NSArray *)types
{
    NSArray *s_types = [m_state objectForKey:TABLE_TYPES];
    
    if(!s_types) {
        NSMutableArray *types = [[NSMutableArray alloc] init];
        
        for(MFType *type in [m_store allObjectsInTable:TABLE_TYPES usingBlock:^id (NSString *key, NSData *value) {
            return [[MFType alloc] initWithAttributes:[value objectFromJSONData]];
        }].objectEnumerator) {
            [types addObject:type];
        }
        
        [m_state setObject:types forKey:TABLE_TYPES];
        s_types = types;
    }
    
    return s_types;
}

- (void)setTypes:(NSArray *)types
{
    if(!types || [m_state objectForKey:TABLE_TYPES] != types) {
        [m_state setValue:types forKey:TABLE_TYPES];
        [m_store removeAllObjectsInTable:TABLE_TYPES];
        
        for(MFType *type in types) {
            [m_store setObject:[type.attributes JSONData] forKey:type.identifier inTable:TABLE_TYPES];
        }
        
        [self addUpdate:MFDatabaseDidChangeTypesNotification change:nil];
    }
}

@end
