//
//  DoraemonMemoryPlugin.m
//  DoraemonKit
//
//  Created by yixiang on 2018/1/25.
//

#import "DoraemonMemoryPlugin.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonMemoryViewController.h"

@implementation DoraemonMemoryPlugin
- (void)pluginDidLoad {
    DoraemonMemoryViewController *vc = [[DoraemonMemoryViewController alloc] init];
    [DoraemonHomeWindow openPlugin:vc];
}
@end
