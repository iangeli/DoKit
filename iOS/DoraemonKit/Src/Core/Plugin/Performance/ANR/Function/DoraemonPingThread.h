//
//  DoraemonPingThread.h
//  DoraemonKit
//
//  Created by yixiang on 2018/6/14.
//

#import <Foundation/Foundation.h>

typedef void (^DoraemonANRTrackerBlock)(NSDictionary *info);

@interface DoraemonPingThread : NSThread
- (instancetype)initWithThreshold:(double)threshold
                          handler:(DoraemonANRTrackerBlock)handler;
@end
