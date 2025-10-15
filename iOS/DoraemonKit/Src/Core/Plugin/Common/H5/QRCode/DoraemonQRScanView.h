//
//  DoraemonQRScanView.h
//  DoraemonKit
//
//  Created by didi on 2020/3/5.
//

#import <UIKit/UIKit.h>
@class DoraemonQRScanView;

NS_ASSUME_NONNULL_BEGIN

@protocol DoraemonQRScanDelegate<NSObject>
@required

- (void)scanView:(DoraemonQRScanView *)scanView pickUpMessage:(NSString *)message;

- (void)scanView:(DoraemonQRScanView *)scanView aroundBrightness:(NSString *)brightnessValue;
@end

@interface DoraemonQRScanView : UIView
@property (nonatomic, weak) id<DoraemonQRScanDelegate> delegate;

@property (nonatomic, assign) CGRect scanRect;

@property (nonatomic, copy) void (^forbidCameraAuth)(void);

@property (nonatomic, copy) void (^unopenCameraAuth)(void);

- (void)startScanning;

- (void)stopScanning;

/**
 可自定义的蒙版View，可在上面添加自定义控件,也可以改变背景颜色，透明度
 默认为50%透明度黑色，遮盖区域依赖scanRect,需先指定scanRect，否则为默认
 */
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIColor *scanLineColor;

@property (nonatomic, strong) UIColor *cornerLineColor;

@property (nonatomic, strong) UIColor *borderLineColor;

@property (nonatomic, assign, getter=isShowScanLine) BOOL showScanLine;

@property (nonatomic, assign, getter=isShowBorderLine) BOOL showBorderLine;

@property (nonatomic, assign, getter=isShowCornerLine) BOOL showCornerLine;
@end

NS_ASSUME_NONNULL_END
