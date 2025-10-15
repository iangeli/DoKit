//
//  DoraemonFPSViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2018/1/3.
//

#import "DoraemonFPSViewController.h"
#import "DoraemonCacheManager.h"
#import "DoraemonFPSOscillogramWindow.h"
#import "DoraemonFPSOscillogramViewController.h"
#import "DoraemonCellSwitch.h"
#import "DoraemonDefine.h"

@interface DoraemonFPSViewController ()<DoraemonSwitchViewDelegate, DoraemonOscillogramWindowDelegate>
@property (nonatomic, strong) DoraemonCellSwitch *switchView;
@end

@implementation DoraemonFPSViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FPS monitor";
    
    _switchView = [[DoraemonCellSwitch alloc] initWithFrame:CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT, self.view.doraemon_width, kDoraemonSizeFromLandscape(104))];
    [_switchView renderUIWithTitle:@"FPS monitor switch" switchOn:[[DoraemonCacheManager sharedInstance] fpsSwitch]];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];
    [[DoraemonFPSOscillogramWindow shareInstance] addDelegate:self];
}

#pragma mark -- DoraemonSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    [[DoraemonCacheManager sharedInstance] saveFpsSwitch:on];
    if(on){
        [[DoraemonFPSOscillogramWindow shareInstance] show];
    }else{
        [[DoraemonFPSOscillogramWindow shareInstance] hide];
    }
}

#pragma mark -- DoraemonOscillogramWindowDelegate
- (void)doraemonOscillogramWindowClosed {
    [_switchView renderUIWithTitle:@"FPS monitor switch" switchOn:[[DoraemonCacheManager sharedInstance] fpsSwitch]];
}
@end
