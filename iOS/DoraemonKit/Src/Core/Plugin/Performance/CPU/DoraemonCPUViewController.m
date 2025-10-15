//
//  DoraemonCPUViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2018/1/12.
//

#import "DoraemonCPUViewController.h"
#import "DoraemonCacheManager.h"
#import "DoraemonCPUOscillogramWindow.h"
#import "DoraemonCPUOscillogramViewController.h"
#import "DoraemonCellSwitch.h"
#import "DoraemonDefine.h"

@interface DoraemonCPUViewController ()<DoraemonSwitchViewDelegate, DoraemonOscillogramWindowDelegate>
@property (nonatomic, strong) DoraemonCellSwitch *switchView;
@end

@implementation DoraemonCPUViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CPU monitor";
    
    _switchView = [[DoraemonCellSwitch alloc] initWithFrame:CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT, self.view.doraemon_width, kDoraemonSizeFromLandscape(104))];
    [_switchView renderUIWithTitle:@"CPU monitor switch" switchOn:[[DoraemonCacheManager sharedInstance] cpuSwitch]];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];
    [[DoraemonCPUOscillogramWindow shareInstance] addDelegate:self];
}

#pragma mark -- DoraemonSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    [[DoraemonCacheManager sharedInstance] saveCpuSwitch:on];
    if(on){
        [[DoraemonCPUOscillogramWindow shareInstance] show];
    }else{
        [[DoraemonCPUOscillogramWindow shareInstance] hide];
    }
}

#pragma mark -- DoraemonOscillogramWindowDelegate
- (void)doraemonOscillogramWindowClosed {
    [_switchView renderUIWithTitle:@"CPU monitor switch" switchOn:[[DoraemonCacheManager sharedInstance] cpuSwitch]];
}
@end
