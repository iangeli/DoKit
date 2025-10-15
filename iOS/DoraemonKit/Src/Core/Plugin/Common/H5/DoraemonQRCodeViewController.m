//
//  DoraemonQRCodeViewController.m
//  DoraemonKit
//
//  Created by love on 2019/5/22.
//

#import "DoraemonQRCodeViewController.h"
#import "DoraemonDefaultWebViewController.h"
#import "DoraemonDefine.h"
#import "DoraemonQRScanView.h"

@interface DoraemonQRCodeViewController ()<DoraemonQRScanDelegate>
@property (nonatomic, strong) DoraemonQRScanView *scanView;
@end
@implementation DoraemonQRCodeViewController
- (void)leftNavBackClick:(id)clickView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"QR Scanning";
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    DoraemonQRScanView *scaner = [[DoraemonQRScanView alloc] initWithFrame:self.view.bounds];
    scaner.delegate = self;
    scaner.showScanLine = YES;
    scaner.showBorderLine = YES;
    scaner.showCornerLine = YES;
    scaner.scanRect = CGRectMake(scaner.doraemon_width/2-kDoraemonSizeFromWidth(480)/2, kDoraemonSizeFromWidth(195), kDoraemonSizeFromWidth(480), kDoraemonSizeFromWidth(480));
    [self.view addSubview:scaner];
    self.scanView = scaner;
    [scaner startScanning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeScanView];
}

- (void)removeScanView{
    if (self.scanView) {
        [self.scanView stopScanning];
        [self.scanView removeFromSuperview];
        self.scanView = nil;
    }
}

#pragma mark -- DoraemonQRScanDelegate
- (void)scanView:(DoraemonQRScanView *)scanView pickUpMessage:(NSString *)message{
    if(message.length>0){
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.QRCodeBlock) {
                self.QRCodeBlock(message);
            }
        }];
    }
}

- (void)scanView:(DoraemonQRScanView *)scanView aroundBrightness:(NSString *)brightnessValue{
    
}
@end
