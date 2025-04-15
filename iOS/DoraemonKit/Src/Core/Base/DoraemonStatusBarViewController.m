//
//  DoraemonStatusBarViewController.m
//  DoraemonKit
//
//  Created byzhangwei on 2019/2/22.
//

#import "DoraemonStatusBarViewController.h"
#import "DoraemonManager.h"

@interface DoraemonStatusBarViewController ()
@end

@implementation DoraemonStatusBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return DoraemonManager.shareInstance.supportedInterfaceOrientations;
}
@end
