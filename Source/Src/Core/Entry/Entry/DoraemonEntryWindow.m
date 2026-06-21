//
//  DoraemonEntryWindow.m
//  dokit
//
//  Created by yixiang on 2017/12/11.
//  Copyright © 2017 yixiang. All rights reserved.
//

#import "DoraemonEntryWindow.h"
#import "DoraemonDefine.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonStatusBarViewController.h"
#import "UIImage+Doraemon.h"
#import "UIView+Doraemon.h"

@interface DoraemonEntryWindow ()
@property (nonatomic, strong) UIButton *entryBtn;
@property (nonatomic, assign) CGFloat kEntryViewSize;
@property (nonatomic) CGPoint startingPosition;
@property (nonatomic, strong) UILabel *entryBtnBlingTextLabel;
@property (nonatomic, strong) NSTimer *semiHideTimer;

@property (nonatomic, readonly) BOOL isDockedAtRight;
@property (nonatomic, readonly) BOOL isSemiHidden;
@end

@implementation DoraemonEntryWindow
- (UIButton *)entryBtn {
    if (!_entryBtn) {
        _entryBtn = [[UIButton alloc] initWithFrame:self.bounds];
        UIImage *image = [[UIImage systemImageNamed:@"apple.logo"] imageWithTintColor:UIColor.whiteColor renderingMode:UIImageRenderingModeAlwaysOriginal];
        [_entryBtn setImage:image forState:UIControlStateNormal];
        _entryBtn.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.5];
        _entryBtn.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2;
        [_entryBtn addTarget:self action:@selector(entryClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _entryBtn;
}

- (BOOL)isDockedAtRight {
    return self.center.x > CGRectGetWidth([UIScreen mainScreen].bounds) / 2.f;
}

- (BOOL)isSemiHidden {
    return self.frame.origin.x < 0 || CGRectGetMaxX(self.frame) > CGRectGetWidth([UIScreen mainScreen].bounds);
}

- (instancetype)initWithStartPoint:(CGPoint)startingPosition {
    self.startingPosition = startingPosition;
    _kEntryViewSize = 48;
    CGFloat x = self.startingPosition.x;
    CGFloat y = self.startingPosition.y;
    CGPoint defaultPosition = DoraemonStartingPosition;
    if (x < 0 || x > (DoraemonWindowWidth - _kEntryViewSize)) {
        x = defaultPosition.x;
    }

    if (y < 0 || y > (DoraemonWindowHeight - _kEntryViewSize)) {
        y = defaultPosition.y;
    }

    self = [super initWithFrame:CGRectMake(x, y, _kEntryViewSize, _kEntryViewSize)];
    if (self) {
        UIScene *scene = [[UIApplication sharedApplication].connectedScenes anyObject];
        if (scene) {
            self.windowScene = (UIWindowScene *)scene;
        }

        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 100.f;
        self.hidden = YES;

        if (!self.rootViewController) {
            self.rootViewController = [[DoraemonStatusBarViewController alloc] init];
        }

        [self.rootViewController.view addSubview:self.entryBtn];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        [self endGesture:self];
    }
    return self;
}

- (void)show {
    self.hidden = NO;
    [self startSemiHideTimer];
}

- (void)showClose:(NSNotification *)notification {
    [self cancelSemiHideTimer];
    if (self.isSemiHidden) {
        [self restoreFromSemiHide];
    }
    [_entryBtn setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    [_entryBtn removeTarget:self action:@selector(showClose:) forControlEvents:UIControlEventTouchUpInside];
    [_entryBtn addTarget:self action:@selector(closePluginClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closePluginClick:(UIButton *)btn {
    [_entryBtn setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    [_entryBtn removeTarget:self action:@selector(closePluginClick:) forControlEvents:UIControlEventTouchUpInside];
    [_entryBtn addTarget:self action:@selector(entryClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)entryClick:(UIButton *)btn {
    [self cancelSemiHideTimer];

    if (self.isSemiHidden) {
        [self restoreFromSemiHide];
    } else {
        if ([DoraemonHomeWindow shareInstance].hidden) {
            [[DoraemonHomeWindow shareInstance] show];
        } else {
            [[DoraemonHomeWindow shareInstance] hide];
        }
    }

    [self startSemiHideTimer];
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    UIView *panView = gesture.view;
    switch (gesture.state) {
    case UIGestureRecognizerStateBegan: {
        [self cancelSemiHideTimer];
        if (self.isSemiHidden) {
            [self restoreFromSemiHide];
        }
    } break;
    case UIGestureRecognizerStateChanged: {
        CGPoint translation = [gesture translationInView:panView];
        [gesture setTranslation:CGPointZero inView:panView];
        panView.center = CGPointMake(panView.center.x + translation.x, panView.center.y + translation.y);
    } break;
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateFailed:
    case UIGestureRecognizerStateCancelled: {
        [self endGesture:panView];
    }
    default:
        break;
    }
}

- (void)endGesture:(UIView *)view {
    CGPoint location = view.center;
    CGFloat centerX;
    CGFloat safeBottom = self.safeAreaInsets.bottom;
    CGFloat centerY = MAX(MIN(location.y, CGRectGetMaxY([UIScreen mainScreen].bounds) - safeBottom), [UIApplication sharedApplication].fetchKeyWindowScene.statusBarManager.statusBarFrame.size.height);
    if (location.x > CGRectGetWidth([UIScreen mainScreen].bounds) / 2.f) {
        centerX = CGRectGetWidth([UIScreen mainScreen].bounds) - _kEntryViewSize / 2;
    } else {
        centerX = _kEntryViewSize / 2;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@{
        @"x" : [NSNumber numberWithFloat:centerX],
        @"y" : [NSNumber numberWithFloat:centerY]
    }
                                              forKey:@"FloatViewCenterLocation"];
    [UIView animateWithDuration:0.3
                     animations:^{
        view.center = CGPointMake(centerX, centerY);
    }
                     completion:^(BOOL finished) {
        [self startSemiHideTimer];
    }];
}

- (void)startSemiHideTimer {
    [self cancelSemiHideTimer];
    self.semiHideTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                          target:self
                                                        selector:@selector(semiHideEntryBtn)
                                                        userInfo:nil
                                                         repeats:NO];
}

- (void)cancelSemiHideTimer {
    [self.semiHideTimer invalidate];
    self.semiHideTimer = nil;
}

- (void)semiHideEntryBtn {
    if (self.isSemiHidden) {
        return;
    }

    CGFloat entrySize = self->_kEntryViewSize;
    CGFloat semiHideOffset = roundf(entrySize * 0.6);
    CGFloat dx = self.isDockedAtRight ? semiHideOffset : -semiHideOffset;

    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectOffset(self.frame, dx, 0);
        self.entryBtn.alpha = 0.6;
        self.entryBtn.frame = CGRectMake(0, 0, entrySize, entrySize);
    }];
}

- (void)restoreFromSemiHide {
    if (!self.isSemiHidden) {
        return;
    }

    CGFloat entrySize = self->_kEntryViewSize;
    CGFloat semiHideOffset = roundf(entrySize * 0.6);
    CGFloat dx = self.isDockedAtRight ? -semiHideOffset : semiHideOffset;

    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:6.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.frame = CGRectOffset(self.frame, dx, 0);
        self.entryBtn.alpha = 1;
        self.entryBtn.frame = CGRectMake(0, 0, entrySize, entrySize);
    }
                     completion:nil];
}

- (void)configEntryBtnBlingWithText:(NSString *)text backColor:(UIColor *)backColor {
    if (text == nil || text.length == 0) {
        [self destoryBlingText];
        return;
    }
    backColor = backColor ?: [UIColor whiteColor];

    if (!self.entryBtnBlingTextLabel) {
        self.entryBtnBlingTextLabel = [[UILabel alloc] initWithFrame:self.entryBtn.bounds];
        self.entryBtnBlingTextLabel.transform = CGAffineTransformMakeScale(0.6, 0.6);
        [self.entryBtn addSubview:self.entryBtnBlingTextLabel];
        self.entryBtnBlingTextLabel.layer.cornerRadius = self.entryBtnBlingTextLabel.bounds.size.width / 2.0;
        self.entryBtnBlingTextLabel.clipsToBounds = YES;
        self.entryBtnBlingTextLabel.font = [UIFont systemFontOfSize:self.entryBtn.bounds.size.width - 10];
        self.entryBtnBlingTextLabel.textAlignment = NSTextAlignmentCenter;
        self.entryBtnBlingTextLabel.textColor = [UIColor whiteColor];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = @1;
        animation.toValue = @0;
        animation.duration = 3.0;
        animation.beginTime = CACurrentMediaTime() + 0;
        animation.repeatCount = HUGE_VALF;
        animation.autoreverses = YES;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeForwards;
        [self.entryBtnBlingTextLabel.layer addAnimation:animation forKey:@"bling"];
    }
    self.entryBtnBlingTextLabel.backgroundColor = backColor;
    self.entryBtnBlingTextLabel.text = [text substringToIndex:1];
}

- (void)destoryBlingText {
    [self.entryBtnBlingTextLabel.layer removeAllAnimations];
    [self.entryBtnBlingTextLabel removeFromSuperview];
    self.entryBtnBlingTextLabel = nil;
}
@end
