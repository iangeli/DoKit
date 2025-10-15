//
//  DoraemonANRTracker.h
//  DoraemonKit
//
//  Created by yixiang on 2018/6/14.
//

#import "DoraemonPingThread.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DoraemonANRTrackerStatus) {
    DoraemonANRTrackerStatusStart,
    DoraemonANRTrackerStatusStop,
};

@interface DoraemonANRTracker : NSObject
- (void)startWithThreshold:(double)threshold
                   handler:(DoraemonANRTrackerBlock)handler;

- (void)stop;

- (DoraemonANRTrackerStatus)status;
@end
