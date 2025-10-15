//
//  DoraemonOscillogramWindow.h
//  DoraemonKit
//
//  Created by yixiang on 2018/1/3.
//

#import "DoraemonOscillogramViewController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DoraemonOscillogramWindowDelegate<NSObject>
- (void)doraemonOscillogramWindowClosed;
@end

@interface DoraemonOscillogramWindow : UIWindow
+ (DoraemonOscillogramWindow *)shareInstance;

@property (nonatomic, strong) DoraemonOscillogramViewController *vc;

- (void)addRootVc;

- (void)show;

- (void)hide;

- (void)addDelegate:(id<DoraemonOscillogramWindowDelegate>)delegate;

- (void)removeDelegate:(id<DoraemonOscillogramWindowDelegate>)delegate;
@end
