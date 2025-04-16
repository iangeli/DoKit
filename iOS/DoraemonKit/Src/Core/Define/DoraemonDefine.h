//
//  DoraemonDefine.h
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//  Copyright © 2017 yixiang. All rights reserved.
//

#ifndef DoraemonDefine_h
#define DoraemonDefine_h

#import "DoraemonAppInfoUtil.h"
#import "UIColor+Doraemon.h"
#import "UIView+Doraemon.h"
#import "UIImage+Doraemon.h"
#import "DoraemonToastUtil.h"
#import "DoraemonAlertUtil.h"
#import "DoraemonUtil.h"

#ifdef DoKit_OpenLog
#define DoKitLog(...) NSLog(@"DoKitLog -> %s\n %@ \n\n",__func__,[NSString stringWithFormat:__VA_ARGS__]);
#else
#define DoKitLog(...)
#endif

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define DoraemonScreenWidth [UIScreen mainScreen].bounds.size.width
#define DoraemonScreenHeight [UIScreen mainScreen].bounds.size.height

#define DoraemonStartingPosition            CGPointMake(0, DoraemonScreenHeight/3.0)

#define DoraemonFullScreenStartingPosition  CGPointZero

#define kDoraemonSizeFrom750(x) ((x)*DoraemonScreenWidth/750)

#define kDoraemonSizeFrom750_Landscape(x) (kInterfaceOrientationLandscape ? ((x)*DoraemonScreenHeight/750) : kDoraemonSizeFrom750(x))

#define kInterfaceOrientationPortrait UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)

#define kInterfaceOrientationLandscape UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)

#define IS_IPHONE_X_Series [DoraemonAppInfoUtil isIPhoneXSeries]
#define IPHONE_NAVIGATIONBAR_HEIGHT  (IS_IPHONE_X_Series ? 88 : 64)
#define IPHONE_STATUSBAR_HEIGHT      (IS_IPHONE_X_Series ? 44 : 20)
#define IPHONE_SAFEBOTTOMAREA_HEIGHT (IS_IPHONE_X_Series ? 34 : 0)

#define STRING_NOT_NULL(str) ((str==nil)?@"":str)

#define DoraemonClosePluginNotification @"DoraemonClosePluginNotification"

#endif /* DoraemonDefine_h */
