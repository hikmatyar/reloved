/* Copyright (c) 2013 Meep Factory OU */

#import <UIKit/UIKit.h>

@interface MFWebController : UIViewController
{
    @private
    NSArray *m_lines;
    NSString *m_path;
}

+ (void)preload;

- (id)initWithContentsOfFile:(NSString *)path;
- (id)initWithContentsOfFile:(NSString *)path title:(NSString *)title;
- (id)initWithContentsOfFile:(NSString *)path title:(NSString *)title lines:(NSArray *)lines;

@property (nonatomic, retain, readonly) NSArray *lines;
@property (nonatomic, retain, readonly) NSString *path;

@end