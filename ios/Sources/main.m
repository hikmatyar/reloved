/* Copyright (c) 2013 Meep Factory OU */

#import "MFApplicationDelegate.h"

// TODO: This blob of code should be removed before submitting to App Store. It's only necessary, because iOS 7 SDK, beta 4+ is completely broken without it.
// WTF @ Apple. Broken beta has been out in the wild for a month. More info: https://devforums.apple.com/message/861803#861803
typedef int (*PYStdWriter)(void *, const char *, int);

static PYStdWriter _oldStdWrite;

int __pyStderrWrite(void *inFD, const char *buffer, int size) {
    if(strncmp(buffer, "AssertMacros:", 13) == 0) {
        return 0;
    }
    
    return _oldStdWrite(inFD, buffer, size);
}

void __iOS7B5CleanConsoleOutput(void) {
    _oldStdWrite = stderr->_write;
    stderr->_write = __pyStderrWrite;
}

int main(int argc, char *argv[])
{
    __iOS7B5CleanConsoleOutput();
    
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
