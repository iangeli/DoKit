//
//  DoraemonNavigationController.m
//  dokit
//
//  Created by Chunhui Sun on 2020/7/14.
//  Copyright © 2020 YunXIao. All rights reserved.
//

#import "DoraemonNavigationController.h"
#import "DoraemonManager.h"

@interface DoraemonNavigationController ()
@end

@implementation DoraemonNavigationController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return DoraemonManager.shareInstance.supportedInterfaceOrientations;
}
@end
