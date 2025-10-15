//
//  DoraemonOscillogramWindow.m
//  DoraemonKit
//
//  Created by yixiang on 2018/1/3.
//

#import "DoraemonOscillogramWindow.h"
#import "DoraemonDefine.h"
#import "DoraemonOscillogramViewController.h"
#import "DoraemonOscillogramWindowManager.h"
#import "UIColor+Doraemon.h"

@interface DoraemonOscillogramWindow ()
@property (nonatomic, strong) NSHashTable *delegates;
@end

@implementation DoraemonOscillogramWindow
- (NSHashTable *)delegates {
    if (_delegates == nil) {
        self.delegates = [NSHashTable weakObjectsHashTable];
    }
    return _delegates;
}

- (void)addDelegate:(id<DoraemonOscillogramWindowDelegate>)delegate {
    [self.delegates addObject:delegate];
}

- (void)removeDelegate:(id<DoraemonOscillogramWindowDelegate>)delegate {
    [self.delegates removeObject:delegate];
}

+ (DoraemonOscillogramWindow *)shareInstance {
    static dispatch_once_t once;
    static DoraemonOscillogramWindow *instance;
    dispatch_once(&once, ^{
        instance = [[DoraemonOscillogramWindow alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = false;
        self.windowLevel = UIWindowLevelStatusBar + 2.f;
        self.backgroundColor = [UIColor doraemon_colorWithHex:0x000000 andAlpha:0.33];
        self.layer.masksToBounds = YES;

        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                self.windowScene = windowScene;
                break;
            }
        }
        [self addRootVc];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize sz = self.frame.size;
    CGPoint pt = self.vc.oscillogramView.frame.origin;
    self.vc.oscillogramView.frame = CGRectMake(pt.x, pt.y, sz.width, sz.height - pt.y);
}

- (void)addRootVc {
}

- (void)show {
    self.hidden = NO;
    [_vc startRecord];
    [self resetLayout];
}

- (void)hide {
    if (self.hidden) {
        return;
    }
    [_vc endRecord];
    self.hidden = YES;
    [self resetLayout];

    for (id<DoraemonOscillogramWindowDelegate> delegate in self.delegates) {
        [delegate doraemonOscillogramWindowClosed];
    }
}

- (void)resetLayout {
    [[DoraemonOscillogramWindowManager shareInstance] resetLayout];
}
@end
