/* Copyright (c) 2013 Meep Factory OU */

#import "UINavigationController+Additions.h"
#import "MFPostController.h"
#import "MFWebPost.h"

@implementation UINavigationController(Additions)

- (BOOL)pushLink:(NSURL *)url animated:(BOOL)animated
{
    if([url.scheme isEqualToString:@"reloved"]) {
        NSArray *components = [url.path componentsSeparatedByString:@"/"];
        
        // reloved://post/12
        if(components.count == 2 && [url.host isEqualToString:@"post"]) {
            NSString *identifier = [components objectAtIndex:1];
            
            if(identifier.length > 0 && identifier.integerValue != 0) {
                MFPostController *controller = [[MFPostController alloc] initWithPost:[[MFWebPost alloc] initWithIdentifier:identifier]];
            
                [self pushViewController:controller animated:animated];
                
                return YES;
            }
        }
    }
    
    return NO;
}

@end
