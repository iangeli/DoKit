//
//  DoraemonBaseViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//  Copyright © 2017 yixiang. All rights reserved.
//

#import "DoraemonBaseViewController.h"
#import "DoraemonNavBarItemModel.h"
#import "UIImage+Doraemon.h"
#import "UIApplication+Doraemon.h"
#import "DoraemonHomeWindow.h"
#import "UIView+Doraemon.h"
#import "DoraemonDefine.h"

@interface DoraemonBaseViewController ()
 
@property (nonatomic, strong) DoraemonNavBarItemModel *leftModel;

@property (nonatomic, strong) NSArray *leftNavBarItemArray;
@end

@implementation DoraemonBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor systemBackgroundColor];
   
    UIImage *image = [UIImage systemImageNamed:@"chevron.backward"];
    self.leftModel = [[DoraemonNavBarItemModel alloc] initWithImage:image selector:@selector(leftNavBackClick:)];
    [self setLeftNavBarItems:@[self.leftModel]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
        UIWindow *keyWindow = [UIApplication sharedApplication].fetchKeyWindow;
        if (appWindow != keyWindow) {
            [appWindow makeKeyWindow];
        }
    }
}

- (void)leftNavBackClick:(id)clickView{
    if (self.navigationController.viewControllers.count==1) {
        [[DoraemonHomeWindow shareInstance] hide];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)setLeftNavBarItems:(NSArray *)items{
    _leftNavBarItemArray = items;
    NSArray *barItems = [self navigationItems:items];
    if (barItems) {
        self.navigationItem.leftBarButtonItems = barItems;
    }
}

- (void)setRightNavBarItems:(NSArray *)items{
    NSArray *barItems = [self navigationItems:items];
    if (barItems) {
        self.navigationItem.rightBarButtonItems = barItems;
    }
}

- (void)setRightNavTitle:(NSString *)title{
    DoraemonNavBarItemModel *item = [[DoraemonNavBarItemModel alloc] initWithText:title color:[UIColor doraemon_blue] selector:@selector(rightNavTitleClick:)];
    NSArray *barItems = [self navigationItems:@[item]];
    if (barItems) {
        self.navigationItem.rightBarButtonItems = barItems;
    }
}

- (NSArray *)navigationItems:(NSArray *)items{
    NSMutableArray *barItems = [NSMutableArray array];
    
    UIBarButtonItem *spacer = [self getSpacerByWidth:-10];
    [barItems addObject:spacer];
    
    for (NSInteger i=0; i<items.count; i++) {
        
        DoraemonNavBarItemModel *model = items[i];
        UIBarButtonItem *barItem;
        if (model.type == DoraemonNavBarItemTypeText) {
            barItem = [[UIBarButtonItem alloc] initWithTitle:model.text style:UIBarButtonItemStylePlain target:self action:model.selector];
            barItem.tintColor = model.textColor;
        }else if(model.type == DoraemonNavBarItemTypeImage){
            UIImage *image = [model.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:image forState:UIControlStateNormal];
            [btn addTarget:self action:model.selector forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(0, 0, 30, 30);
            btn.clipsToBounds = YES;
            barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }else{
            barItem = [[UIBarButtonItem alloc] init];
        }
        [barItems addObject:barItem];
    }
    return barItems;
}

- (UIBarButtonItem *)getSpacerByWidth : (CGFloat)width{
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil action:nil];

    spacer.width = width;
    return spacer;
}

- (void)rightNavTitleClick:(id)clickView{
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
