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
#import "DoraemonHomeWindow.h"
#import "UIView+Doraemon.h"
#import "DoraemonDefine.h"

@interface DoraemonBaseViewController ()<DoraemonBaseBigTitleViewDelegate>
 
@property (nonatomic, strong) DoraemonNavBarItemModel *leftModel;

@property (nonatomic, strong) NSArray *leftNavBarItemArray;
@end

@implementation DoraemonBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor labelColor]}];
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        [self.navigationController.navigationBar setShadowImage:[UIImage doraemon_imageWithColor:[UIColor doraemon_black_3] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
    }

    if ([self needBigTitleView]) {
        _bigTitleView = [[DoraemonBaseBigTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.doraemon_width, kDoraemonSizeFrom750_Landscape(178))];
        _bigTitleView.delegate = self;
        [self.view addSubview:_bigTitleView];
    } else {
        UIImage *image = [UIImage doraemon_xcassetImageNamed:@"doraemon_back"];

        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            image = [UIImage doraemon_xcassetImageNamed:@"doraemon_back_dark"];
        }

        self.leftModel = [[DoraemonNavBarItemModel alloc] initWithImage:image selector:@selector(leftNavBackClick:)];
        [self setLeftNavBarItems:@[self.leftModel]];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = [self needBigTitleView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (appWindow != keyWindow) {
            [appWindow makeKeyWindow];
        }
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];

    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            self.leftModel.image = [UIImage doraemon_xcassetImageNamed:@"doraemon_back_dark"];
            [self.navigationController.navigationBar setShadowImage:[UIImage doraemon_imageWithColor:[UIColor doraemon_black_3] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
        } else {
            self.leftModel.image = [UIImage doraemon_xcassetImageNamed:@"doraemon_back"];
        }
        if (self.leftNavBarItemArray) {
            [self setLeftNavBarItems:self.leftNavBarItemArray];
        }
    }
}

- (BOOL)needBigTitleView{
    return NO;
}

- (void)setTitle:(NSString *)title{
    if (_bigTitleView && !_bigTitleView.hidden) {
        [_bigTitleView setTitle:title];
    }else{
        [super setTitle:title];
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

#pragma mark - DoraemonBaseBigTitleViewDelegate
- (void)bigTitleCloseClick{
    [self leftNavBackClick:nil];
}

- (void)rightNavTitleClick:(id)clickView{
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
