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

@property(nonatomic,copy) void(^forbidCameraAuth)(void);

@property(nonatomic,copy) void(^unopenCameraAuth)(void);

- (void)startScanning;

- (void)stopScanning;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIColor *scanLineColor;

@property (nonatomic, strong) UIColor *cornerLineColor;

@property (nonatomic, strong) UIColor *borderLineColor;

@property (nonatomic, assign, getter=isShowScanLine) BOOL showScanLine;

@property (nonatomic, assign, getter=isShowBorderLine) BOOL showBorderLine;

@property (nonatomic, assign, getter=isShowCornerLine) BOOL showCornerLine;
@end

NS_ASSUME_NONNULL_END
