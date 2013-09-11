/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFWebController : UIViewController
{
    @private
    NSString *m_path;
}

+ (void)preload;

- (id)initWithContentsOfFile:(NSString *)path;
- (id)initWithContentsOfFile:(NSString *)path title:(NSString *)title;

@property (nonatomic, retain, readonly) NSString *path;

@end
