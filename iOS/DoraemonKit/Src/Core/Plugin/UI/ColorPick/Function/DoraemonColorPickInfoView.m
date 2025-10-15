//
//  DoraemonColorPickInfoView.m
//  DoraemonKit
//
//  Created by wenquan on 2018/12/3.
//

#import "DoraemonColorPickInfoView.h"
#import "DoraemonDefine.h"

@interface DoraemonColorPickInfoView ()
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UILabel *colorValueLbl;
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation DoraemonColorPickInfoView
#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor systemBackgroundColor];
    self.layer.cornerRadius = kDoraemonSizeFromLandscape(8);
    self.layer.borderWidth = 1.;
    self.layer.borderColor = [UIColor doraemon_colorWithHex:0x999999 andAlpha:0.2].CGColor;
    
    [self addSubview:self.colorView];
    [self addSubview:self.colorValueLbl];
    [self addSubview:self.closeBtn];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat colorWidth = kDoraemonSizeFromLandscape(28);
    CGFloat colorHeight = kDoraemonSizeFromLandscape(28);
    self.colorView.frame = CGRectMake(kDoraemonSizeFromLandscape(32), (self.doraemon_height - colorHeight) / 2.0, colorWidth, colorHeight);
    
    CGFloat colorValueWidth = kDoraemonSizeFromLandscape(150);
    self.colorValueLbl.frame = CGRectMake(self.colorView.doraemon_right + kDoraemonSizeFromLandscape(20), 0, colorValueWidth, self.doraemon_height);
    
    CGFloat closeWidth = kDoraemonSizeFromLandscape(44);
    CGFloat closeHeight = kDoraemonSizeFromLandscape(44);
    self.closeBtn.frame = CGRectMake(self.doraemon_width - closeWidth - kDoraemonSizeFromLandscape(32), (self.doraemon_height - closeHeight) / 2.0, closeWidth, closeHeight);
}

#pragma mark - Public

- (void)setCurrentColor:(NSString *)hexColor{
    self.colorView.backgroundColor = [UIColor doraemon_colorWithHexString:hexColor];
    self.colorValueLbl.text = hexColor;
}

#pragma mark - Actions

- (void)closeBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(closeBtnClicked:onColorPickInfoView:)]) {
        [self.delegate closeBtnClicked:sender onColorPickInfoView:self];
    }
}

#pragma mark - Private
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPoint = [touch locationInView:self];
    
    CGPoint prePoint = [touch previousLocationInView:self];
    CGFloat offsetX = currentPoint.x - prePoint.x;
    CGFloat offsetY = currentPoint.y - prePoint.y;

    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
}

#pragma mark - Getter

- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.layer.borderWidth = 1.;
        _colorView.layer.borderColor = [UIColor doraemon_colorWithHex:0x999999 andAlpha:0.2].CGColor;
    }
    return _colorView;
}

- (UILabel *)colorValueLbl {
    if (!_colorValueLbl) {
        _colorValueLbl = [[UILabel alloc] init];
        _colorValueLbl.textColor = [UIColor doraemon_black_1];
        _colorValueLbl.font = [UIFont systemFontOfSize:kDoraemonSizeFromLandscape(28)];
    }
    return _colorValueLbl;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        UIImage *closeImage = [UIImage systemImageNamed:@"xmark"];
        [_closeBtn setBackgroundImage:closeImage forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
@end
