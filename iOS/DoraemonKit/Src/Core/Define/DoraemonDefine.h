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
#import "UIApplication+Doraemon.h"
#import "DoraemonToastUtil.h"
#import "DoraemonAlertUtil.h"
#import "DoraemonUtil.h"

#ifdef DoKit_OpenLog
#define DoKitLog(...) NSLog(@"DoKitLog -> %s\n %@ \n\n",__func__,[NSString stringWithFormat:__VA_ARGS__]);
#else
#define DoKitLog(...)
#endif

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define DoraemonWindowWidth [UIApplication sharedApplication].fetchKeyWindow.frame.size.width
#define DoraemonWindowHeight [UIApplication sharedApplication].fetchKeyWindow.frame.size.height

#define DoraemonStartingPosition            CGPointMake(0, DoraemonWindowHeight/3.0)

#define DoraemonFullScreenStartingPosition  CGPointZero

#define kDoraemonSizeFromWidth(x) ((x)*MIN(DoraemonWindowWidth, 750)/750)
#define kDoraemonSizeFromHeight(x) ((x)*MIN(DoraemonWindowHeight, 750)/750)

#define kDoraemonSizeFromLandscape(x) ([UIApplication sharedApplication].fetchKeyWindow.orientationIsLandscape ? kDoraemonSizeFromHeight(x) : kDoraemonSizeFromWidth(x))

#define IS_IPHONE_X_Series [DoraemonAppInfoUtil isIPhoneXSeries]
#define IPHONE_NAVIGATIONBAR_HEIGHT  (IS_IPHONE_X_Series ? 88 : 64)
#define IPHONE_STATUSBAR_HEIGHT      (IS_IPHONE_X_Series ? 44 : 20)
#define IPHONE_SAFEBOTTOMAREA_HEIGHT (IS_IPHONE_X_Series ? 34 : 0)

#define STRING_NOT_NULL(str) ((str==nil)?@"":str)

#define DoraemonClosePluginNotification @"DoraemonClosePluginNotification"

#endif /* DoraemonDefine_h */
