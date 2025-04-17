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
    return @"CPU";
}

- (NSString *)lowValue{
    return @"1";
}

- (NSString *)highValue{
    return @"100";
}

- (void)doSecondFunction {
    CGFloat cpuUsage = [DoraemonCPUUtil cpuUsageForApp];
    cpuUsage = MIN(MAX(cpuUsage, 0), 1);
    [self.oscillogramView addHeightValue:cpuUsage * self.oscillogramView.doraemon_height
                             andTipValue:[NSString stringWithFormat:@"%.f",cpuUsage * 100]];
}
@end
