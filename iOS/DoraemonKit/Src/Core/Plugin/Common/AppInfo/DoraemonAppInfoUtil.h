//
//  DoraemonAppInfoUtil.h
//  DoraemonKit
//
//  Created by yixiang on 2018/4/15.
//

#import <Foundation/Foundation.h>

@interface DoraemonAppInfoUtil : NSObject
+ (NSString *)appName;

+ (NSString *)iphoneName;

+ (NSString *)iphoneSystemVersion;

+ (NSString *)bundleIdentifier;

+ (NSString *)bundleVersion;

+ (NSString *)bundleShortVersionString;

+ (NSString *)iphoneType;

+ (BOOL)isIPhoneXSeries;

+ (BOOL)isIpad;

+ (NSString *)locationAuthority;

+ (NSString *)pushAuthority;

+ (NSString *)cameraAuthority;

+ (NSString *)audioAuthority;

+ (NSString *)photoAuthority;

+ (NSString *)addressAuthority;

+ (NSString *)calendarAuthority;

+ (NSString *)remindAuthority;

+ (NSString *)bluetoothAuthority;

+ (BOOL)isSimulator;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSString *)uuid;
@end
