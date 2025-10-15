//
//  DoraemonHierarchyWindow.m
//  DoraemonKit
//
//  Created by lijiahuan on 2019/11/2.
//

#import "DoraemonHierarchyWindow.h"
#import "DoraemonDefine.h"
#import "DoraemonHierarchyViewController.h"

@interface DoraemonHierarchyWindow ()
@end

@implementation DoraemonHierarchyWindow
- (instancetype)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                self.windowScene = windowScene;
                break;
            }
        }
        self.windowLevel = UIWindowLevelAlert - 1;
        if (!self.rootViewController) {
            self.rootViewController = [[DoraemonHierarchyViewController alloc] init];
        }
    }
    return self;
}

- (void)show {
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
}
@end
