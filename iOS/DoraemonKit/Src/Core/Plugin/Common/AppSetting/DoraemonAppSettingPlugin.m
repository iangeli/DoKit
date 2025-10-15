//
//  DoraemonAppSettingPlugin.m
//  DoraemonKit
//
//  Created by didi on 2020/2/28.
//

#import "DoraemonAppSettingPlugin.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonUtil.h"

@implementation DoraemonAppSettingPlugin
- (void)pluginDidLoad {
    [DoraemonUtil openAppSetting];
    [[DoraemonHomeWindow shareInstance] hide];
}
@end
