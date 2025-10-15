//
//  DoraemonUIProfileViewController.m
//  DoraemonKit
//
//  Created by xgb on 2019/8/1.
//

#import "DoraemonUIProfileViewController.h"
#import "DoraemonCellSwitch.h"
#import "DoraemonDefine.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonUIProfileManager.h"

@interface DoraemonUIProfileViewController ()<DoraemonSwitchViewDelegate>
@property (nonatomic, strong) DoraemonCellSwitch *switchView;
@end

@implementation DoraemonUIProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"UI Hierarchy";

    _switchView = [[DoraemonCellSwitch alloc] initWithFrame:CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT, self.view.doraemon_width, kDoraemonSizeFromWidth(104))];
    [_switchView renderUIWithTitle:@"UI Hierarchy switch" switchOn:[DoraemonUIProfileManager sharedInstance].enable];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];
}

#pragma mark-- DoraemonSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender {
    [DoraemonUIProfileManager sharedInstance].enable = on;
    [[DoraemonHomeWindow shareInstance] hide];
}
@end
