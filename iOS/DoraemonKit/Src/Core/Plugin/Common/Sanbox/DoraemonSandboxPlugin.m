//
//  DoraemonSandboxPlugin.m
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//

#import "DoraemonSandboxPlugin.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonSandboxViewController.h"

@implementation DoraemonSandboxPlugin
- (void)pluginDidLoad {
    DoraemonSandboxViewController *vc = [[DoraemonSandboxViewController alloc] init];
    [DoraemonHomeWindow openPlugin:vc];
}
@end
