//
//  DoraemonMockGPSOperateView.m
//  DoraemonKit
//
//  Created by yixiang on 2018/12/2.
//

#import "DoraemonMockGPSOperateView.h"
#import "DoraemonDefine.h"

@interface DoraemonMockGPSOperateView()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation DoraemonMockGPSOperateView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

            self.backgroundColor = [UIColor systemBackgroundColor];

        self.layer.cornerRadius = kDoraemonSizeFrom750_Landscape(8);
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFrom750_Landscape(32)];
        _titleLabel.textColor = [UIColor doraemon_black_1];
        _titleLabel.text = @"Open Mock GPS";
        [self addSubview:_titleLabel];
        [_titleLabel sizeToFit];
        _titleLabel.frame = CGRectMake(kDoraemonSizeFrom750_Landscape(32), self.doraemon_height/2-_titleLabel.doraemon_height/2, _titleLabel.doraemon_width, _titleLabel.doraemon_height);
        
        _switchView = [[UISwitch alloc] init];
        _switchView.onTintColor = [UIColor doraemon_blue];
        _switchView.doraemon_origin = CGPointMake(self.doraemon_width-kDoraemonSizeFrom750_Landscape(32)-_switchView.doraemon_width, self.doraemon_height/2-_switchView.doraemon_height/2);
        [self addSubview:_switchView];
    }
    return self;
}
@end
