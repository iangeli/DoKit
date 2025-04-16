//
//  DoraemonANRViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2018/6/13.
//

#import "DoraemonANRViewController.h"
#import "DoraemonCellSwitch.h"
#import "UIView+Doraemon.h"
#import "DoraemonANRManager.h"
#import "DoraemonCellButton.h"
#import "DoraemonANRListViewController.h"
#import "DoraemonANRTool.h"
#import "DoraemonDefine.h"

@interface DoraemonANRViewController () <DoraemonSwitchViewDelegate, DoraemonCellButtonDelegate>
@property (nonatomic, strong) DoraemonCellSwitch *switchView;
@property (nonatomic, strong) DoraemonCellButton *checkBtn;
@property (nonatomic, strong) DoraemonCellButton *clearBtn;
@end

@implementation DoraemonANRViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ANR Check";
    
    self.switchView = [[DoraemonCellSwitch alloc] initWithFrame:CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT, self.view.doraemon_width, 53)];
    [self.switchView renderUIWithTitle:@"ANR Switch" switchOn:[DoraemonANRManager sharedInstance].anrTrackOn];
    [self.switchView needTopLine];
    [self.switchView needDownLine];
    self.switchView.delegate = self;
    [self.view addSubview:self.switchView];
    
    self.checkBtn = [[DoraemonCellButton alloc] initWithFrame:CGRectMake(0, _switchView.doraemon_bottom, self.view.doraemon_width, 53)];
    [self.checkBtn renderUIWithTitle:@"View ANR"];
    self.checkBtn.delegate = self;
    [self.checkBtn needDownLine];
    [self.view addSubview:self.checkBtn];
    
    self.clearBtn = [[DoraemonCellButton alloc] initWithFrame:CGRectMake(0, self.checkBtn.doraemon_bottom, self.view.doraemon_width, kDoraemonSizeFrom750_Landscape(104))];
    [self.clearBtn renderUIWithTitle:@"Delete ANR track"];
    self.clearBtn.delegate = self;
    [self.clearBtn needDownLine];
    [self.view addSubview:self.clearBtn];
}

#pragma mark -- DoraemonSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender {
    [DoraemonANRManager sharedInstance].anrTrackOn = on;
    if (on) {
        [[DoraemonANRManager sharedInstance] start];
    } else {
        [[DoraemonANRManager sharedInstance] stop];
    }
}

#pragma mark -- DoraemonCellButtonDelegate
- (void)cellBtnClick:(id)sender {
    if (sender == self.checkBtn) {
        DoraemonANRListViewController *vc = [[DoraemonANRListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender == self.clearBtn) {
           UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Tip" message:@"Confirm to delete all ANR tracks?" preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           }];
           UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               NSFileManager *fm = [NSFileManager defaultManager];
               if ([fm removeItemAtPath:[DoraemonANRTool anrDirectory] error:nil]) {
                   [DoraemonToastUtil showToast:@"Delete Success" inView:self.view];
               } else {
                   [DoraemonToastUtil showToast:@"Delete fail" inView:self.view];
               }
           }];
           [alertController addAction:cancelAction];
           [alertController addAction:okAction];
           [self presentViewController:alertController animated:YES completion:nil];
       }
}
@end
