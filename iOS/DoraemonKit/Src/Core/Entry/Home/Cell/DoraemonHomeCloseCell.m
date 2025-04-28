//
//  DoraemonHomeCloseCell.m
//  DoraemonKit
//
//  Created by dengyouhua on 2019/9/4.
//

#import "DoraemonHomeCloseCell.h"
#import "DoraemonManager.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonDefine.h"
#import "UIViewController+Doraemon.h"

@interface DoraemonHomeCloseCell ()
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation DoraemonHomeCloseCell
- (void)closeButtonHandle{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Tip" message:@"Reboot to open Doraemon" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[DoraemonManager shareInstance] hiddenDoraemon];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [[UIViewController rootViewControllerForKeyWindow] presentViewController:alertController animated:YES completion:nil];

    [[DoraemonHomeWindow shareInstance] hide];
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFrom750_Landscape(28)];
        [_closeButton addTarget:self action:@selector(closeButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.closeButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = kDoraemonSizeFrom750_Landscape(10);

    self.closeButton.frame = CGRectMake(x, 0, self.doraemon_width - x * 2, kDoraemonSizeFrom750_Landscape(100));
}
@end
