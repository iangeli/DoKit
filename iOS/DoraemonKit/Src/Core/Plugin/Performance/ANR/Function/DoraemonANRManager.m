//
//  DoraemonANRManager.m
//  DoraemonKit
//
//  Created by yixiang on 2018/6/14.
//

#import "DoraemonANRManager.h"
#import "DoraemonANRTool.h"
#import "DoraemonANRTracker.h"
#import "DoraemonAppInfoUtil.h"
#import "DoraemonCacheManager.h"
#import "DoraemonMemoryUtil.h"

static CGFloat const kDoraemonBlockMonitorTimeInterval = 0.2f;

@interface DoraemonANRManager ()
@property (nonatomic, strong) DoraemonANRTracker *doraemonANRTracker;
@property (nonatomic, copy) DoraemonANRManagerBlock block;
@end

@implementation DoraemonANRManager
+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _doraemonANRTracker = [[DoraemonANRTracker alloc] init];
        _timeOut = kDoraemonBlockMonitorTimeInterval;
        _anrTrackOn = [DoraemonCacheManager sharedInstance].anrTrackSwitch;
        if (_anrTrackOn) {
            [self start];
        } else {
            [self stop];

            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:[DoraemonANRTool anrDirectory] error:nil];
        }
    }

    return self;
}

- (void)start {
    __weak typeof(self) weakSelf = self;
    [_doraemonANRTracker startWithThreshold:self.timeOut
                                    handler:^(NSDictionary *info) {
                                        __strong typeof(weakSelf) strongSelf = weakSelf;
                                        [strongSelf dumpWithInfo:info];
                                    }];
}

- (void)dumpWithInfo:(NSDictionary *)info {
    if (![info isKindOfClass:[NSDictionary class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.block) {
            self.block(info);
        }
        [DoraemonANRTool saveANRInfo:info];
    });
}

- (void)addANRBlock:(DoraemonANRManagerBlock)block {
    self.block = block;
}

- (void)dealloc {
    [self stop];
}

- (void)stop {
    [self.doraemonANRTracker stop];
}

- (void)setAnrTrackOn:(BOOL)anrTrackOn {
    _anrTrackOn = anrTrackOn;
    [[DoraemonCacheManager sharedInstance] saveANRTrackSwitch:anrTrackOn];
}
@end
