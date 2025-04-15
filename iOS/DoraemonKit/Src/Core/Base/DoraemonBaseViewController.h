//
//  DoraemonBaseViewController.h
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//  Copyright © 2017 yixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoraemonBaseBigTitleView.h"

@interface DoraemonBaseViewController : UIViewController
- (BOOL)needBigTitleView;
@property (nonatomic, strong) DoraemonBaseBigTitleView *bigTitleView;

- (void)setLeftNavBarItems:(NSArray *)items;
- (void)leftNavBackClick:(id)clickView;
- (void)setRightNavTitle:(NSString *)title;
- (void)rightNavTitleClick:(id)clickView;
- (void)setRightNavBarItems:(NSArray *)items;
@end
