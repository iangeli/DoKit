//
//  DoraemonViewCheckPlugin.m
//  DoraemonKit
//
//  Created by yixiang on 2018/3/28.
//

#import "DoraemonViewCheckPlugin.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonViewCheckManager.h"

@implementation DoraemonViewCheckPlugin
- (void)pluginDidLoad {
    [[DoraemonViewCheckManager shareInstance] show];
    [[DoraemonHomeWindow shareInstance] hide];
}
@end
