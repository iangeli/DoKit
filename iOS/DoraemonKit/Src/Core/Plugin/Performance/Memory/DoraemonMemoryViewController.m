//
//  DoraemonMemoryViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2018/1/25.
//

#import "DoraemonMemoryViewController.h"
#import "DoraemonCacheManager.h"
#import "DoraemonMemoryOscillogramWindow.h"
#import "DoraemonMemoryOscillogramViewController.h"
#import "DoraemonCellSwitch.h"
#import "DoraemonDefine.h"

@interface DoraemonMemoryViewController ()<DoraemonSwitchViewDelegate, DoraemonOscillogramWindowDelegate>
@property (nonatomic, strong) DoraemonCellSwitch *switchView;
@end

@implementation DoraemonMemoryViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Memory monitor";
    
    _switchView = [[DoraemonCellSwitch alloc] initWithFrame:CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT, self.view.doraemon_width, kDoraemonSizeFrom750_Landscape(104))];
    [_switchView renderUIWithTitle:@"Memory monitor switch" switchOn:[[DoraemonCacheManager sharedInstance] memorySwitch]];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];
    [[DoraemonMemoryOscillogramWindow shareInstance] addDelegate:self];
}

#pragma mark -- DoraemonSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    [[DoraemonCacheManager sharedInstance] saveMemorySwitch:on];
    if(on){
        [[DoraemonMemoryOscillogramWindow shareInstance] show];
    }else{
        [[DoraemonMemoryOscillogramWindow shareInstance] hide];
    }
}

#pragma mark -- DoraemonOscillogramWindowDelegate
- (void)doraemonOscillogramWindowClosed {
    [_switchView renderUIWithTitle:@"Memory monitor switch" switchOn:[[DoraemonCacheManager sharedInstance] memorySwitch]];
}
@end
