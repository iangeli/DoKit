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
    CGFloat useMemoryForApp = (CGFloat)[DoraemonMemoryUtil useMemoryForApp];
    CGFloat totalMemoryForDevice = (CGFloat)[self.highValue floatValue];
    CGFloat ratio = MIN(useMemoryForApp / totalMemoryForDevice, 1);
    NSString *tip = [NSString stringWithFormat:@"%.0lfM", useMemoryForApp];
    if (useMemoryForApp > 1000) {
        tip = [NSString stringWithFormat:@"%.1lfG", useMemoryForApp / 1000];
    }

    [self.oscillogramView addHeightValue:ratio * self.oscillogramView.doraemon_height andTipValue:tip];
}

- (NSUInteger)deviceMemory {
    return 1000;
}
@end
