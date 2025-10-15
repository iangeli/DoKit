//
//  DoraemonDBShowView.m
//  DoraemonKit
//
//  Created by yixiang on 2019/4/1.
//

#import "DoraemonDBShowView.h"
#import "DoraemonDefine.h"

@interface DoraemonDBShowView ()
@property (nonatomic, strong) UITextView *displayTextView;
@end

@implementation DoraemonDBShowView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _displayTextView = [[UITextView alloc] init];
        _displayTextView.font = [UIFont systemFontOfSize:16.0];
        _displayTextView.editable = NO;
        _displayTextView.textAlignment = NSTextAlignmentCenter;
        _displayTextView.backgroundColor = [UIColor doraemon_black_2];
        _displayTextView.textColor = [UIColor labelColor];
        [self addSubview:_displayTextView];
    }
    return self;
}

- (void)showText:(NSString *)text {
    _displayTextView.frame = CGRectMake(self.doraemon_width / 2 - 150 / 2, self.doraemon_height / 2 - 100 / 2, 150, 100);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25
        animations:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.displayTextView.frame = CGRectMake(self.doraemon_width / 2 - 300 / 2, self.doraemon_height / 2 - 200 / 2, 300, 200);
        }
        completion:^(BOOL finished) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.displayTextView.text = text;
        }];
}
@end
