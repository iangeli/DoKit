//
//  DoraemonHomeHeadCell.m
//  DoraemonKit
//
//  Created by dengyouhua on 2019/9/4.
//

#import "DoraemonHomeHeadCell.h"
#import "DoraemonDefine.h"

@interface DoraemonHomeHeadCell()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation DoraemonHomeHeadCell
- (UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
    }
    
    return _title;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.title];
    }
    return self;
}

- (void)renderUIWithTitle:(NSString *)title{
    _title.text = title;
    _title.font = [UIFont systemFontOfSize:kDoraemonSizeFromLandscape(24)];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.title sizeToFit];
    self.title.frame = CGRectMake(kDoraemonSizeFromLandscape(32), self.doraemon_height/2-self.title.doraemon_height/2, self.title.doraemon_width, self.title.doraemon_height);
    if (self.subTitleLabel) {
        [self.subTitleLabel sizeToFit];
        self.subTitleLabel.frame = CGRectMake(self.title.doraemon_right+kDoraemonSizeFromLandscape(2), self.doraemon_height/2-self.subTitleLabel.doraemon_height/2, self.subTitleLabel.doraemon_width, self.subTitleLabel.doraemon_height);
    }
}
@end
