/* Copyright (c) 2013 Meep Factory OU */

#import "UITableView+Additions.h"

@implementation UITableView(Additions)

- (void)clearSelection
{
    NSIndexPath *selection = self.indexPathForSelectedRow;
    
    if(selection) {
        [self deselectRowAtIndexPath:selection animated:NO];
    }
}

@end