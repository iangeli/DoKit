//
//  UIApplication+Doraemon.m
//  DoraemonKit
//
//  Created by yixiang on 2018/7/2.
//

#import "NSObject+Doraemon.h"
#import <objc/runtime.h>

@implementation UIApplication (Doraemon)

- (UIWindowScene *)fetchKeyWindowScene {
    UIWindowScene *temp = nil;
    for (UIScene *scene in self.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            temp = (UIWindowScene *)scene;
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return windowScene;
                    }
                }
            }
        }
    }
    return temp;
}

- (UIWindow *)fetchKeyWindow {
    UIWindowScene *temp = nil;
    for (UIScene *scene in self.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            temp = (UIWindowScene *)scene;
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    }
    return temp.windows.firstObject;
}

@end
