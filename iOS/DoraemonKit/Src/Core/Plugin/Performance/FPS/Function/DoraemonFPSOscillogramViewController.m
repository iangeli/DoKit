//
//  DoraemonFPSOscillogramViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2018/1/12.
//

#import "DoraemonFPSOscillogramViewController.h"
#import "DoraemonOscillogramView.h"
#import "DoraemonDefine.h"
#import "DoraemonCacheManager.h"
#import "DoraemonFPSOscillogramWindow.h"
#import "DoraemonFPSUtil.h"

@interface DoraemonFPSOscillogramViewController ()
@property (nonatomic, strong) DoraemonFPSUtil *fpsUtil;
@end

@implementation DoraemonFPSOscillogramViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)title{
    return @"FPS";
}

- (NSString *)lowValue{
    return @"1";
}

- (NSString *)highValue{
    return @"60";
}

- (void)startRecord{
    if (!_fpsUtil) {
        _fpsUtil = [[DoraemonFPSUtil alloc] init];
        __weak typeof(self) weakSelf = self;
        [_fpsUtil addFPSBlock:^(NSInteger fps) {
            [weakSelf.oscillogramView addHeightValue:fps*weakSelf.oscillogramView.doraemon_height/60. andTipValue:[NSString stringWithFormat:@"%zi",fps]];
        }];
    }
    [_fpsUtil start];
}

- (void)endRecord{
    if (_fpsUtil) {
        [_fpsUtil end];
    }
    [self.oscillogramView clear];
}
@end
