/* Copyright (c) 2013 Meep Factory OU */

#import "MFApplicationDelegate.h"

int main(int argc, char *argv[])
{
#if DEBUG
    int result = -1;
    
    @autoreleasepool {
        @try {
            result = UIApplicationMain(argc, argv, nil, NSStringFromClass([MFApplicationDelegate class]));
        }
        @catch(NSException *exception) {
            MFLog(@"Uncaught exception: %@", exception.description);
            MFLog(@"Stack trace: %@", exception.callStackSymbols);
            
            @throw exception;
        }
    }
    
    return result;
#else
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([MFApplicationDelegate class]));
    }
#endif
}
