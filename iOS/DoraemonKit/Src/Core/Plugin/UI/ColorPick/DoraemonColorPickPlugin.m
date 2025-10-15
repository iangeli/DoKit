//
//  DoraemonColorPickPlugin.m
//  DoraemonKit
//
//  Created by yixiang on 2018/3/5.
//

#import "DoraemonColorPickPlugin.h"
#import "DoraemonColorPickInfoWindow.h"
#import "DoraemonColorPickWindow.h"
#import "DoraemonHomeWindow.h"

@implementation DoraemonColorPickPlugin
- (void)pluginDidLoad {
    [[DoraemonColorPickWindow shareInstance] show];
    [[DoraemonColorPickInfoWindow shareInstance] show];
    [[DoraemonHomeWindow shareInstance] hide];
}
@end
