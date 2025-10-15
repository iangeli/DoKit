//
//  DoraemonNSUserDefaultsPlugin.m
//  DoraemonKit
//
//  Created by 0xd-cc on 2019/11/26.
//

#import "DoraemonNSUserDefaultsPlugin.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonNSUserDefaultsViewController.h"

@implementation DoraemonNSUserDefaultsPlugin
- (void)pluginDidLoad {
    DoraemonNSUserDefaultsViewController *vc = [[DoraemonNSUserDefaultsViewController alloc] init];
    [DoraemonHomeWindow openPlugin:vc];
}
@end
