//
//  UIViewController+Doraemon.h
//  DoraemonKit
//
//  Created by dengyouhua on 2019/9/5.
//
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Doraemon)
// safe area inset
- (UIEdgeInsets)safeAreaInset;

- (CGRect) fullscreen;

// key window root vc
+ (UIViewController *)rootViewControllerForKeyWindow;

// key window top vc
+ (UIViewController *)topViewControllerForKeyWindow;

+ (UIViewController *)rootViewControllerForDoraemonHomeWindow;
@end

NS_ASSUME_NONNULL_END
