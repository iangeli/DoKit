//
//  DoraemonMockGPSInputView.m
//  DoraemonKit
//
//  Created by yixiang on 2018/12/2.
//

#import "DoraemonMockGPSInputView.h"
#import "DoraemonDefine.h"

@interface DoraemonMockGPSInputView ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *exampleLabel;
@end

@implementation DoraemonMockGPSInputView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = kDoraemonSizeFromLandscape(8);

        _textField = [[UITextField alloc] initWithFrame:CGRectMake(kDoraemonSizeFromLandscape(32), kDoraemonSizeFromLandscape(40), self.doraemon_width - 2 * kDoraemonSizeFromLandscape(32), kDoraemonSizeFromLandscape(45))];
        _textField.placeholder = @"Please enter latitude and longitude";
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];

        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.doraemon_width - kDoraemonSizeFromLandscape(120), 0, kDoraemonSizeFromLandscape(120), kDoraemonSizeFromLandscape(120))];
        _searchBtn.imageView.contentMode = UIViewContentModeCenter;
        [_searchBtn setImage:[UIImage doraemon_xcassetImageNamed:@"doraemon_search"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_searchBtn];

        _lineView = [[UIView alloc] initWithFrame:CGRectMake(kDoraemonSizeFromLandscape(32), _textField.doraemon_bottom + kDoraemonSizeFromLandscape(19), self.doraemon_width - 2 * kDoraemonSizeFromLandscape(32), 1)];
        _lineView.backgroundColor = [UIColor doraemon_colorWithHexString:@"#EEEEEE"];
        [self addSubview:_lineView];

        _exampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDoraemonSizeFromLandscape(32), _lineView.doraemon_bottom + kDoraemonSizeFromLandscape(15), self.doraemon_width - kDoraemonSizeFromLandscape(32), kDoraemonSizeFromLandscape(33))];
        _exampleLabel.textColor = [UIColor doraemon_black_3];
        _exampleLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFromLandscape(24)];
        _exampleLabel.text = @"(Like: 120.15 30.28)";
        [self addSubview:_exampleLabel];
        self.backgroundColor = [UIColor systemBackgroundColor];
    }
    return self;
}

- (void)textFieldDidChange:(id)sender {
    UITextField *senderTextField = (UITextField *)sender;

    NSString *textSearchStr = [senderTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (textSearchStr.length > 0) {
        [_searchBtn setImage:[UIImage doraemon_xcassetImageNamed:@"doraemon_search_highlight"] forState:UIControlStateNormal];
    } else {
        [_searchBtn setImage:[UIImage doraemon_xcassetImageNamed:@"doraemon_search"] forState:UIControlStateNormal];
    }
}

- (void)searchBtnClick:(id)sender {

    NSString *textSearchStr = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (textSearchStr.length > 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(inputViewOkClick:)]) {
            [_delegate inputViewOkClick:textSearchStr];
        }
    }
}
@end
