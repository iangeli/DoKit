//
//  DoraemonUIProfilePlugin.m
//  DoraemonKit
//
//  Created by xgb on 2019/8/1.
//

#import "DoraemonUIProfilePlugin.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonUIProfileViewController.h"

@implementation DoraemonUIProfilePlugin
- (void)pluginDidLoad {
    DoraemonUIProfileViewController *vc = [[DoraemonUIProfileViewController alloc] init];
    [DoraemonHomeWindow openPlugin:vc];
}
@end
