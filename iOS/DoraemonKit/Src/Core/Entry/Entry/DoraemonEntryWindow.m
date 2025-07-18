//
//  DoraemonEntryWindow.m
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//  Copyright © 2017 yixiang. All rights reserved.
//

#import "DoraemonEntryWindow.h"
#import "DoraemonDefine.h"
#import "UIView+Doraemon.h"
#import "UIImage+Doraemon.h"
#import "DoraemonDefine.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonStatusBarViewController.h"

@interface DoraemonEntryWindow()
@property (nonatomic, strong) UIButton *entryBtn;
@property (nonatomic, assign) CGFloat kEntryViewSize;
@property (nonatomic) CGPoint startingPosition;
@property (nonatomic, strong) UILabel *entryBtnBlingTextLabel;
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

- (instancetype)initWithStartPoint:(CGPoint)startingPosition{
    self.startingPosition = startingPosition;
    _kEntryViewSize = 48;
    CGFloat x = self.startingPosition.x;
    CGFloat y = self.startingPosition.y;
    CGPoint defaultPosition = DoraemonStartingPosition;
    if (x < 0 || x > (DoraemonScreenWidth - _kEntryViewSize)) {
        x = defaultPosition.x;
    }
    
    if (y < 0 || y > (DoraemonScreenHeight - _kEntryViewSize)) {
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
        self.layer.masksToBounds = YES;
        self.hidden = YES;

        if (!self.rootViewController) {
            self.rootViewController = [[DoraemonStatusBarViewController alloc] init];
        }

        [self.rootViewController.view addSubview:self.entryBtn];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)show {
    self.hidden = NO;
}

- (void)showClose:(NSNotification *)notification{
    [_entryBtn setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    [_entryBtn removeTarget:self action:@selector(showClose:) forControlEvents:UIControlEventTouchUpInside];
    [_entryBtn addTarget:self action:@selector(closePluginClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closePluginClick:(UIButton *)btn{
    [_entryBtn setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    [_entryBtn removeTarget:self action:@selector(closePluginClick:) forControlEvents:UIControlEventTouchUpInside];
    [_entryBtn addTarget:self action:@selector(entryClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)entryClick:(UIButton *)btn{
    if ([DoraemonHomeWindow shareInstance].hidden) {
        [[DoraemonHomeWindow shareInstance] show];
    }else{
        [[DoraemonHomeWindow shareInstance] hide];
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    if (self.autoDock) {
        [self autoDocking:pan];
    }else{
        [self normalMode:pan];
    }
}

- (void)normalMode: (UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint offsetPoint = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
    UIView *panView = panGestureRecognizer.view;
    CGFloat newX = panView.doraemon_centerX+offsetPoint.x;
    CGFloat newY = panView.doraemon_centerY+offsetPoint.y;
    if (newX < _kEntryViewSize/2) {
        newX = _kEntryViewSize/2;
    }
    if (newX > DoraemonScreenWidth - _kEntryViewSize/2) {
        newX = DoraemonScreenWidth - _kEntryViewSize/2;
    }
    if (newY < _kEntryViewSize/2) {
        newY = _kEntryViewSize/2;
    }
    if (newY > DoraemonScreenHeight - _kEntryViewSize/2) {
        newY = DoraemonScreenHeight - _kEntryViewSize/2;
    }
    panView.center = CGPointMake(newX, newY);
}

- (void)autoDocking:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIView *panView = panGestureRecognizer.view;
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGestureRecognizer translationInView:panView];
            [panGestureRecognizer setTranslation:CGPointZero inView:panView];
            panView.center = CGPointMake(panView.center.x + translation.x, panView.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint location = panView.center;
            CGFloat centerX;
            CGFloat safeBottom = self.safeAreaInsets.bottom;
            CGFloat centerY = MAX(MIN(location.y, CGRectGetMaxY([UIScreen mainScreen].bounds)-safeBottom), [UIApplication sharedApplication].fetchKeyWindowScene.statusBarManager.statusBarFrame.size.height);
            if(location.x > CGRectGetWidth([UIScreen mainScreen].bounds)/2.f)
            {
                centerX = CGRectGetWidth([UIScreen mainScreen].bounds)-_kEntryViewSize/2;
            }
            else
            {
                centerX = _kEntryViewSize/2;
            }
            [[NSUserDefaults standardUserDefaults] setObject:@{
                                                               @"x":[NSNumber numberWithFloat:centerX],
                                                               @"y":[NSNumber numberWithFloat:centerY]
                                                               } forKey:@"FloatViewCenterLocation"];
            [UIView animateWithDuration:0.3 animations:^{
                panView.center = CGPointMake(centerX, centerY);
            }];
        }

        default:
            break;
    }
}

- (void)setAutoDock:(BOOL)autoDock {
    _autoDock = autoDock;
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"FloatViewCenterLocation"];
    if (dict && dict[@"x"] && dict[@"y"]) {
        self.center = CGPointMake([dict[@"x"] integerValue], [dict[@"y"] integerValue]);
    }
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
        self.entryBtnBlingTextLabel.layer.cornerRadius = self.entryBtnBlingTextLabel.bounds.size.width/2.0;
        self.entryBtnBlingTextLabel.clipsToBounds = YES;
        self.entryBtnBlingTextLabel.font = [UIFont systemFontOfSize:self.entryBtn.bounds.size.width - 10];
        self.entryBtnBlingTextLabel.textAlignment = NSTextAlignmentCenter;
        self.entryBtnBlingTextLabel.textColor = [UIColor whiteColor];
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = @1;
        animation.toValue = @0;
        animation.duration = 3.0;
        animation.beginTime = CACurrentMediaTime() + 0;
        animation.repeatCount = HUGE_VALF ;
        animation.autoreverses = YES;
        animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
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
