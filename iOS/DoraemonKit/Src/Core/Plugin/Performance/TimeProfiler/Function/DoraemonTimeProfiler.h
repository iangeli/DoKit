//
//  DoraemonTimeProfiler.h
//  DoraemonKit
//
//  Created by yixiang on 2019/7/10.
//

#import <Foundation/Foundation.h>
#import "DoraemonTimeProfilerRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoraemonTimeProfiler : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, assign) BOOL on;

+ (void)startRecord;

+ (void)stopRecord;

+ (void)clearRecords;

+ (void)shareRecords;

+ (void)printRecords;

+ (NSArray<DoraemonTimeProfilerRecord *> *)getRecords;

+ (void)setMinCallCost:(double)ms;

+ (void)setMaxCallDepth:(int)depth;
@end

NS_ASSUME_NONNULL_END
