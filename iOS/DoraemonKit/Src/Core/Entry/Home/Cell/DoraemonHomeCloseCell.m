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
        UIColor *dyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor whiteColor];
            } else {
                return [UIColor doraemon_colorWithString:@"#C1C3BF"];
            }
        }];
        _closeButton.backgroundColor = dyColor;
        _closeButton.layer.cornerRadius = kDoraemonSizeFrom750_Landscape(5.0);
        _closeButton.layer.masksToBounds = YES;
        [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor doraemon_colorWithString:@"#CC3A4B"] forState:UIControlStateNormal];
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
