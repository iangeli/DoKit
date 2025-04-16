//
//  DoraemonOscillogramWindowManager.m
//  DoraemonKit
//
//  Created by yixiang on 2019/5/16.
//

#import "DoraemonOscillogramWindowManager.h"
#import "DoraemonFPSOscillogramWindow.h"
#import "DoraemonCPUOscillogramWindow.h"
#import "DoraemonMemoryOscillogramWindow.h"
#import "DoraemonDefine.h"

@interface DoraemonOscillogramWindowManager()
@property (nonatomic, strong) DoraemonFPSOscillogramWindow *fpsWindow;
@property (nonatomic, strong) DoraemonCPUOscillogramWindow *cpuWindow;
@property (nonatomic, strong) DoraemonMemoryOscillogramWindow *memoryWindow;
@end

@implementation DoraemonOscillogramWindowManager
+ (DoraemonOscillogramWindowManager *)shareInstance{
    static dispatch_once_t once;
    static DoraemonOscillogramWindowManager *instance;
    dispatch_once(&once, ^{
        instance = [[DoraemonOscillogramWindowManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _fpsWindow = [DoraemonFPSOscillogramWindow shareInstance];
        _cpuWindow = [DoraemonCPUOscillogramWindow shareInstance];
        _memoryWindow = [DoraemonMemoryOscillogramWindow shareInstance];
    }
    return self;
}

- (void)resetLayout{
    CGFloat offsetX = 0;
    CGFloat offsetY = IS_IPHONE_X_Series ? 32 : 0;
    CGFloat width = kInterfaceOrientationPortrait ? DoraemonScreenWidth:DoraemonScreenHeight;
    CGFloat height = 60;

    __block NSInteger count = 0;
    [@[_fpsWindow, _cpuWindow, _memoryWindow] enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isHidden) {
            count += 1;
        }
    }];

    if (count == 0) {
        return;
    }
    width = width / count;
    if (!_fpsWindow.hidden) {
        _fpsWindow.frame = CGRectMake(offsetX, offsetY, width, height);
        offsetX += width;
    }
    
    if (!_cpuWindow.hidden) {
        _cpuWindow.frame = CGRectMake(offsetX, offsetY, width, height);
        offsetX += width;
    }
    
    if (!_memoryWindow.hidden) {
        _memoryWindow.frame = CGRectMake(offsetX, offsetY, width, height);
    }
}
@end
