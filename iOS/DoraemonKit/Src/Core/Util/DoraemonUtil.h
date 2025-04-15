//
//  DoraemonUtil.h
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//  Copyright © 2017 yixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DoraemonUtil : NSObject
@property (nonatomic, assign) NSInteger fileSize;
@property (nonatomic, strong) NSMutableArray *bigFileArray;

+ (NSString *)dateFormatTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)dateFormatNSDate:(NSDate *)date;

+ (NSString *)dateFormatNow;

+ (NSString *)formatByte:(CGFloat)byte;

+ (void)savePerformanceDataInFile:(NSString *)fileName data:(NSString *)data;

+ (NSString *)dictToJsonStr:(NSDictionary *)dict;

+ (NSString *)arrayToJsonStr:(NSArray *)array;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;

+ (NSString *)formatTimeIntervalToMS:(NSTimeInterval)timeInterval;

+ (NSString *)currentTimeInterval;

- (void)getFileSizeWithPath:(NSString *)path;

- (NSArray *)getBigSizeFileFormPath:(NSString *)path;

+ (void)clearFileWithPath:(NSString *)path;

+ (void)clearLocalDatas;

+ (void)shareText:(NSString *)text formVC:(UIViewController *)vc;//share text
+ (void)shareImage:(UIImage *)image formVC:(UIViewController *)vc;//share image
+ (void)shareURL:(NSURL *)url formVC:(UIViewController *)vc;//share url

+ (void)openAppSetting;

+ (UIWindow *)getKeyWindow;

+ (NSArray *)getWebViews;

+ (void)openPlugin:(UIViewController *)vc __attribute__((deprecated("[DoraemonHomeWindow openPlugin:vc];")));

+ (UIViewController *)rootViewControllerForKeyWindow __attribute__((deprecated("[UIViewController rootViewControllerForKeyWindow]")));

+ (UIViewController *)topViewControllerForKeyWindow __attribute__((deprecated("[UIViewController topViewControllerForKeyWindow]")));
@end
