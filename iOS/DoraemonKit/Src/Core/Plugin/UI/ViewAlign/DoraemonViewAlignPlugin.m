//
//  DoraemonViewAlignPlugin.m
//  DoraemonKit
//
//  Created by yixiang on 2018/6/16.
//

#import "DoraemonViewAlignPlugin.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonViewAlignManager.h"

@implementation DoraemonViewAlignPlugin
- (void)pluginDidLoad {
    [[DoraemonViewAlignManager shareInstance] show];
    [[DoraemonHomeWindow shareInstance] hide];
}
@end
