//
//  DoraemonBaseBigTitleView.m
//  DoraemonKit
//
//  Created by yixiang on 2018/12/2.
//

#import "DoraemonBaseBigTitleView.h"
#import "DoraemonDefine.h"
#import "UIView+Doraemon.h"
#import "UIColor+Doraemon.h"
#import "UIImage+Doraemon.h"

@interface DoraemonBaseBigTitleView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *downLine;
@end

@implementation DoraemonBaseBigTitleView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat offsetY = IPHONE_STATUSBAR_HEIGHT;
        CGFloat titleLabelOffsetY = offsetY + ((self.doraemon_height-offsetY)/2-kDoraemonSizeFrom750_Landscape(67)/2);
        CGFloat closeBtnH = self.doraemon_height-offsetY;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDoraemonSizeFrom750_Landscape(32), titleLabelOffsetY, self.doraemon_width-kDoraemonSizeFrom750_Landscape(32)-closeBtnH, kDoraemonSizeFrom750_Landscape(67))];
        
        UIImage *closeImage = [UIImage systemImageNamed:@"xmark"];
        self.backgroundColor = [UIColor systemBackgroundColor];

        _titleLabel.textColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor whiteColor];
            } else {
                return [UIColor doraemon_colorWithString:@"#324456"];
            }
        }];

        _titleLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFrom750_Landscape(48)];
        [self addSubview:_titleLabel];

        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.doraemon_width-closeBtnH, offsetY, closeBtnH, closeBtnH)];
        _closeBtn.imageView.contentMode = UIViewContentModeCenter;
        [_closeBtn setImage:closeImage forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        
        _downLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.doraemon_height-1, self.doraemon_width, 1)];
        _downLine.backgroundColor = [UIColor doraemon_line];
        [self addSubview:_downLine];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

- (void)closeClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bigTitleCloseClick)]) {
        [self.delegate bigTitleCloseClick];
    }
}
@end
