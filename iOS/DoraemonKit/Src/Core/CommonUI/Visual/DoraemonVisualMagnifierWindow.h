//
//  DoraemonVisualMagnifierWindow.h
//  DoraemonKit
//
//  Created by wenquan on 2018/12/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoraemonVisualMagnifierWindow : UIWindow
@property (nonatomic, assign) CGFloat magnifierSize;

@property (nonatomic, assign) CGFloat magnification;

@property (nonatomic, strong) UIView *targetWindow;

@property (nonatomic, assign) CGPoint targetPoint;
@end

NS_ASSUME_NONNULL_END
