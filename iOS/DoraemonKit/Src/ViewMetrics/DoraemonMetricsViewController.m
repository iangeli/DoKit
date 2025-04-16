//
//  DoraemonMetricsViewController.m
//  DoraemonKit
//
//  Created by xgb on 2019/1/10.
//

#import "DoraemonMetricsViewController.h"
#import "DoraemonCellSwitch.h"
#import "DoraemonDefine.h"
#import "DoraemonViewMetricsConfig.h"

@interface DoraemonMetricsViewController () <DoraemonSwitchViewDelegate>
@property (nonatomic, strong) DoraemonCellSwitch *switchView;
@end

@implementation DoraemonMetricsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"View Border";
    
    _switchView = [[DoraemonCellSwitch alloc] initWithFrame:CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT, self.view.doraemon_width, kDoraemonSizeFrom750_Landscape(104))];
    [_switchView renderUIWithTitle:@"View border switch" switchOn:[DoraemonViewMetricsConfig defaultConfig].enable];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];
}

#pragma mark -- DoraemonSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    [DoraemonViewMetricsConfig defaultConfig].opened = YES;
    [DoraemonViewMetricsConfig defaultConfig].enable = on;
}
@end
