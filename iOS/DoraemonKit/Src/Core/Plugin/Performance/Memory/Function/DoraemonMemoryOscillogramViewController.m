//
//  DoraemonMemoryOscillogramViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2018/1/25.
//

#import "DoraemonMemoryOscillogramViewController.h"
#import "DoraemonOscillogramView.h"
#import "UIView+Doraemon.h"
#import "DoraemonMemoryUtil.h"
#import "DoraemonDefine.h"
#import "DoraemonCacheManager.h"
#import "DoraemonMemoryOscillogramWindow.h"

@interface DoraemonMemoryOscillogramViewController ()
@end

@implementation DoraemonMemoryOscillogramViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)title{
    return @"Memory monitor";
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return [NSString stringWithFormat:@"%zi",[self deviceMemory]];
}

- (void)closeBtnClick{
    [[DoraemonCacheManager sharedInstance] saveMemorySwitch:NO];
    [[DoraemonMemoryOscillogramWindow shareInstance] hide];
}

- (void)doSecondFunction{
    NSUInteger useMemoryForApp = [DoraemonMemoryUtil useMemoryForApp];
    NSUInteger totalMemoryForDevice = [self deviceMemory];
    
    [self.oscillogramView addHeightValue:useMemoryForApp*self.oscillogramView.doraemon_height/totalMemoryForDevice andTipValue:[NSString stringWithFormat:@"%zi",useMemoryForApp]];
}

- (NSUInteger)deviceMemory {
    return 1000;
}
@end
