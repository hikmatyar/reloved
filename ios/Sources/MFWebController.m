/* Copyright (c) 2013 Meep Factory OU */

#import "MFWebController.h"

@interface MFWebController_Delegate : NSObject <UIWebViewDelegate>

@end

@implementation MFWebController_Delegate

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

@end

#pragma mark -

@implementation MFWebController

+ (UIWebView *)sharedWebView
{
    __strong static MFWebController_Delegate *sharedWebDelegate = nil;
    __strong static UIWebView *sharedWebView = nil;
    static dispatch_once_t loaded = 0;
    
    dispatch_once(&loaded, ^{
        sharedWebDelegate = [[MFWebController_Delegate alloc] init];
        sharedWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
        sharedWebView.delegate = sharedWebDelegate;
        [sharedWebView loadHTMLString:@"<html><body></body></html>" baseURL:nil];
    });
    
    return sharedWebView;
}

+ (void)preload
{
    [self sharedWebView];
}

- (id)initWithContentsOfFile:(NSString *)path
{
    return [self initWithContentsOfFile:path title:nil lines:nil];
}

- (id)initWithContentsOfFile:(NSString *)path title:(NSString *)title
{
    return [self initWithContentsOfFile:path title:title lines:nil];
}

- (id)initWithContentsOfFile:(NSString *)path title:(NSString *)title lines:(NSArray *)lines
{
    self = [super init];
    
    if(self) {
        m_lines = lines;
        m_path = path;
        self.navigationItem.title = title;
    }
    
    return self;
}

@synthesize lines = m_lines;
@synthesize path = m_path;

#pragma mark UIView

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    NSString *path = ([m_path hasPrefix:@"/"]) ? m_path : [[NSBundle mainBundle] pathForResource:m_path ofType:@"html" inDirectory:@"Pages"];
    UIWebView *webView = [self.class sharedWebView];
    NSString *html;
    
    if(webView.superview) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, 320.0F, 480.0F)];
    } else {
        webView.frame = CGRectMake(0.0F, 0.0F, 320.0F, 480.0F);
    }
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:webView];
    
    html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    if(m_lines) {
        NSMutableString *lines = [[NSMutableString alloc] init];
        
        [lines appendString:@"<ul>"];
        
        for(NSString *line in m_lines) {
            [lines appendFormat:@"<li>%@</li>", [[line stringByReplacingOccurrencesOfString:@"&" withString:@"&amp"] stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]];
        }
        
        [lines appendString:@"</ul>"];
        
        html = [html stringByReplacingOccurrencesOfString:@"[[LINES]]" withString:lines];
    }
    
    [webView loadHTMLString:html
                    baseURL:[NSURL fileURLWithPath:path.stringByDeletingLastPathComponent]];
    
    self.view = view;
}

@end
