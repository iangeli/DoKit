//
//  DoraemonDefaultWebViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2018/12/27.
//

#import "DoraemonDefaultWebViewController.h"
#import <WebKit/WebKit.h>
#import "DoraemonDefine.h"

@interface DoraemonDefaultWebViewController ()
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation DoraemonDefaultWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Doraemon Built-in browser";

    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.h5Url]]];
    
    [self.view addSubview:self.progressView];
    [self.view bringSubviewToFront:self.progressView];

    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([@"estimatedProgress" isEqualToString:keyPath]) {
        self.progressView.alpha = 1.0;
        NSLog(@"loding Progress: %lf", self.webView.estimatedProgress);
        
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        
        if (self.webView.estimatedProgress >= 1.0) {
            [UIView animateWithDuration:0.3f delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0 animated:NO];
            }];
        }
    }
}

#pragma mark - Lazy Loading
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0.0, IPHONE_NAVIGATIONBAR_HEIGHT, DoraemonScreenWidth, 1.0)];
        _progressView.tintColor = [UIColor doraemon_blue];      
        _progressView.trackTintColor = [UIColor whiteColor];    
    }
    return _progressView;
}
@end
