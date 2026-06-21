//
//  DoraemonUtil.h
//  dokit
//
//  Created by yixiang on 2017/12/11.
//  Copyright © 2017 yixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DoraemonUtil : NSObject
@property (nonatomic, assign) NSInteger fileSize;

+ (NSString *)dateFormatNow;

+ (NSString *)formatTimeIntervalToMS:(NSTimeInterval)timeInterval;

+ (NSString *)currentTimeInterval;

- (void)getFileSizeWithPath:(NSString *)path;

+ (void)clearFileWithPath:(NSString *)path;

+ (void)clearLocalDatas;

+ (void)shareURL:(NSURL *)url formVC:(UIViewController *)vc;

+ (void)openAppSetting;

+ (UIWindow *)getKeyWindow;

+ (NSArray *)getWebViews;
@end
