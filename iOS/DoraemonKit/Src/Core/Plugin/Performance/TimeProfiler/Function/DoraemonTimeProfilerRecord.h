//
//  DoraemonTimeProfilerRecord.h
//  DoraemonKit
//
//  Created by yixiang on 2019/7/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoraemonTimeProfilerRecord : NSObject
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *methodName;
@property (nonatomic, assign) BOOL isClassMethod;
@property (nonatomic, assign) NSTimeInterval timeCost;
@property (nonatomic, assign) NSUInteger callDepth;
@property (nonatomic, strong) NSArray<DoraemonTimeProfilerRecord *> *subRecords;

- (NSString *)descriptionWithDepth;
@end

NS_ASSUME_NONNULL_END
