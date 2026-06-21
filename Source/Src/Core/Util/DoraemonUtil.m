//
//  DoraemonUtil.m
//  dokit
//
//  Created by yixiang on 2017/12/11.
//  Copyright © 2017 yixiang. All rights reserved.
//

#import "DoraemonUtil.h"
#import "DoraemonAppInfoUtil.h"
#import "DoraemonDefine.h"
#import <WebKit/WebKit.h>

@implementation DoraemonUtil
- (instancetype)init {
    self = [super init];
    if (self) {
        _fileSize = 0;
    }
    return self;
}

+ (NSString *)dateFormatNow {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)formatTimeIntervalToMS:(NSTimeInterval)timeInterval {
    CGFloat ms = timeInterval * 1000;
    return [NSString stringWithFormat:@"%.0f", ms];
}

+ (NSString *)currentTimeInterval {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%0.f", timeInterval];
}

- (void)getFileSizeWithPath:(NSString *)path {
    NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (isDir) {

            NSArray *dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
            NSString *subPath = nil;
            for (NSString *str in dirArray) {
                subPath = [path stringByAppendingPathComponent:str];
                [self getFileSizeWithPath:subPath];
            }
        } else {

            NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            NSInteger size = [dict[@"NSFileSize"] integerValue];
            _fileSize += size;
        }
    } else {

        DoKitLog(@"The file does not exist");
    }
}

+ (void)clearFileWithPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *files = [fm subpathsAtPath:path];
    for (NSString *file in files) {
        NSError *error;
        NSString *filePath = [path stringByAppendingPathComponent:file];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (!error) {
                NSLog(@"remove file: %@", file);
            }
        }
    }
}

+ (void)clearLocalDatas {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *homePath = NSHomeDirectory();
        NSArray *folders = @[ @"Documents", @"Library", @"tmp" ];
        for (NSString *folder in folders) {
            [DoraemonUtil clearFileWithPath:[homePath stringByAppendingPathComponent:folder]];
        }
    });
}

+ (void)shareURL:(NSURL *)url formVC:(UIViewController *)vc {
    [self share:url formVC:vc];
}

+ (void)share:(id)object formVC:(UIViewController *)vc {
    if (!object) {
        return;
    }
    NSArray *objectsToShare = @[ object ]; // support NSString、NSURL、UIImage

    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];

    if ([DoraemonAppInfoUtil isIpad]) {
        if ([controller respondsToSelector:@selector(popoverPresentationController)]) {
            controller.popoverPresentationController.sourceView = vc.view;
            controller.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
            controller.popoverPresentationController.sourceRect = CGRectMake(vc.view.frame.size.width / 2.0, vc.view.frame.size.height / 2.0, 1.0, 1.0);
        }
        [vc presentViewController:controller animated:YES completion:nil];
    } else {
        [vc presentViewController:controller animated:YES completion:nil];
    }
}

+ (void)openAppSetting {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

+ (UIWindow *)getKeyWindow {
    __block UIWindow *keyWindow = nil;
    for (UIWindowScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:UIWindowScene.class] && scene.activationState == UISceneActivationStateForegroundActive) {
            keyWindow = scene.windows.firstObject;
            break;
        }
    }

    if (keyWindow == nil) {
        [[UIApplication sharedApplication].connectedScenes enumerateObjectsUsingBlock:^(UIScene *_Nonnull obj, BOOL *_Nonnull stop) {
            if ([obj isKindOfClass:UIWindowScene.class]) {
                keyWindow = ((UIWindowScene *)obj).windows.firstObject;
                *stop = true;
            }
        }];
    }
    return keyWindow;
}

+ (NSArray *)getWebViews {
    NSMutableArray *webViews = [NSMutableArray array];
    [webViews addObjectsFromArray:[[self getKeyWindow] doraemon_findViewsForClass:WKWebView.class]];
    return webViews;
}
@end
