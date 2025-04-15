//
//  DoraemonCPUOscillogramViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2018/1/12.
//

#import "DoraemonCPUOscillogramViewController.h"
#import "DoraemonOscillogramView.h"
#import "DoraemonCPUUtil.h"
#import "DoraemonDefine.h"
#import "DoraemonCacheManager.h"
#import "DoraemonCPUOscillogramWindow.h"

@interface DoraemonCPUOscillogramViewController ()
@end

@implementation DoraemonCPUOscillogramViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)title{
    return @"CPU monitor";
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return @"100";
}

- (void)closeBtnClick{
    [[DoraemonCacheManager sharedInstance] saveCpuSwitch:NO];
    [[DoraemonCPUOscillogramWindow shareInstance] hide];
}

- (void)doSecondFunction{
    CGFloat cpuUsage = [DoraemonCPUUtil cpuUsageForApp];
    if (cpuUsage * 100 > 100) {
        cpuUsage = 100;
    }else{
        cpuUsage = cpuUsage * 100;
    }
    [self.oscillogramView addHeightValue:cpuUsage*self.oscillogramView.doraemon_height/100. andTipValue:[NSString stringWithFormat:@"%.f",cpuUsage]];
}
@end
