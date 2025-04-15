//
//  DoraemonPingThread.m
//  DoraemonKit
//
//  Created by yixiang on 2018/6/14.
//

#import "DoraemonPingThread.h"
#import <UIKit/UIKit.h>
#import "DoraemonUtil.h"
#import "DoraemonBacktraceLogger.h"

@interface DoraemonPingThread()
@property (nonatomic, assign) BOOL isApplicationInActive;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, assign) double threshold;

@property (nonatomic, copy) DoraemonANRTrackerBlock handler;

@property (nonatomic, assign,getter=isMainThreadBlock) BOOL mainThreadBlock;

@property (nonatomic, copy) NSString *reportInfo;

@property (nonatomic, assign) double startTimeValue;
@end

@implementation DoraemonPingThread
- (instancetype)initWithThreshold:(double)threshold
                          handler:(DoraemonANRTrackerBlock)handler {
    self = [super init];
    if (self) {
        self.semaphore = dispatch_semaphore_create(0);
        
        self.threshold = threshold;
        self.handler = handler;
        _isApplicationInActive = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidBecomeActive) name: UIApplicationDidBecomeActiveNotification object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidEnterBackground) name: UIApplicationDidEnterBackgroundNotification object: nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)main {
    
    __weak typeof(self) weakSelf = self;
    void (^ verifyReport)(void) = ^() {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.reportInfo.length > 0) {
            if (strongSelf.handler) {
                double responseTimeValue = [[NSDate date] timeIntervalSince1970];
                double duration = (responseTimeValue - strongSelf.startTimeValue)*1000;
                strongSelf.handler(@{
                                     @"title": [DoraemonUtil dateFormatNow].length > 0 ? [DoraemonUtil dateFormatNow] : @"",
                                     @"duration": [NSString stringWithFormat:@"%.0f",duration],
                                     @"content": strongSelf.reportInfo
                                     });
            }
            strongSelf.reportInfo = @"";
        }
    };
    
    while (!self.cancelled) {
        if (_isApplicationInActive) {
            self.mainThreadBlock = YES;
            self.reportInfo = @"";
            self.startTimeValue = [[NSDate date] timeIntervalSince1970];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.mainThreadBlock = NO;
                verifyReport();
                dispatch_semaphore_signal(self.semaphore);
            });
            [NSThread sleepForTimeInterval:self.threshold];
            if (self.isMainThreadBlock) {
                self.reportInfo = [DoraemonBacktraceLogger doraemon_backtraceOfMainThread];
            }
            dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC));
            {
                
                verifyReport();
            }
        } else {
            [NSThread sleepForTimeInterval:self.threshold];
        }
    }
}

#pragma mark - Notific ation
- (void)applicationDidBecomeActive {
    _isApplicationInActive = YES;
}

- (void)applicationDidEnterBackground {
    _isApplicationInActive = NO;
}
@end
