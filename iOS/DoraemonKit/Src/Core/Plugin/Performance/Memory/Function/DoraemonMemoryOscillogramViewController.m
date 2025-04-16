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
    return @"Memory";
}

- (NSString *)lowValue{
    return @"1";
}

- (NSString *)highValue{
    return @"600";
}

- (void)doSecondFunction{
    NSUInteger useMemoryForApp = [DoraemonMemoryUtil useMemoryForApp];
    NSUInteger totalMemoryForDevice = [self.highValue floatValue]; // 1G
    CGFloat ratio = MIN(useMemoryForApp / totalMemoryForDevice, 1);
    [self.oscillogramView addHeightValue:ratio * self.oscillogramView.doraemon_height andTipValue:[NSString stringWithFormat:@"%zi", useMemoryForApp]];
}

- (NSUInteger)deviceMemory {
    return 1000;
}
@end
