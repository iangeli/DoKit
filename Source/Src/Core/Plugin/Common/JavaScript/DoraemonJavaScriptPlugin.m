//
//  DoraemonJavaScriptPlugin.m
//  AFNetworking
//
//  Created by carefree on 2022/5/11.
//

#import "DoraemonJavaScriptPlugin.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonJavaScriptManager.h"

@implementation DoraemonJavaScriptPlugin
- (void)pluginDidLoad {
    [[DoraemonHomeWindow shareInstance] hide];
    [[DoraemonJavaScriptManager shareInstance] show];
}
@end
