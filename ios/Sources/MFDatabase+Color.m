/* Copyright (c) 2013 Meep Factory OU */

#import "JSONKit.h"
#import "MFColor.h"
#import "MFDatabase+Color.h"
#import "SQLObjectStore.h"

NSString *MFDatabaseDidChangeColorsNotification = @"MFDatabaseDidChangeColors";

#define TABLE_COLORS @"colors"

@implementation MFDatabase(Color)

@dynamic colors;

- (NSArray *)colors
{
    NSArray *s_colors = [m_state objectForKey:TABLE_COLORS];
    
    if(!s_colors) {
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        
        for(MFColor *color in [m_store allObjectsInTable:TABLE_COLORS usingBlock:^id (NSString *key, NSData *value) {
            return [[MFColor alloc] initWithAttributes:[value objectFromJSONData]];
        }].objectEnumerator) {
            [colors addObject:color];
        }
        
        [m_state setObject:colors forKey:TABLE_COLORS];
        s_colors = colors;
    }
    
    return s_colors;
}

- (void)setColors:(NSArray *)colors
{
    if(!colors || [m_state objectForKey:TABLE_COLORS] != colors) {
        [m_state setValue:colors forKey:TABLE_COLORS];
        [m_store removeAllObjectsInTable:TABLE_COLORS];
        
        for(MFColor *color in colors) {
            [m_store setObject:[color.attributes JSONData] forKey:color.identifier inTable:TABLE_COLORS];
        }
        
        [self addUpdate:MFDatabaseDidChangeColorsNotification change:nil];
    }
}

- (MFColor *)colorForIdentifier:(NSString *)identifier
{
    for(MFColor *color in self.colors) {
        if([identifier isEqualToString:color.identifier]) {
            return color;
        }
    }
    
    return nil;
}

- (NSArray *)colorsForIdentifiers:(NSArray *)identifiers
{
    NSMutableArray *colors = nil;
    
    for(MFColor *color in self.colors) {
        if([identifiers containsObject:color.identifier]) {
            if(!colors) {
                colors = [NSMutableArray array];
            }
            
            [colors addObject:color];
        }
    }
    
    return colors;
}

@end
