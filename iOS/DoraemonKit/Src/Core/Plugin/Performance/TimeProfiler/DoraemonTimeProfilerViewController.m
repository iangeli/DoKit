//
//  DoraemonTimeProfilerViewController.m
//  DoraemonKit
//
//  Created by didi on 2019/10/15.
//

#import "DoraemonTimeProfilerViewController.h"
#import "DoraemonDefine.h"

@interface DoraemonTimeProfilerViewController ()
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation DoraemonTimeProfilerViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Time Profiler";

    NSString *contet = @"\n\n\n This function does not provide a UI operation interface，\n before the code you need to analyze, insert \n\n [DoraemonTimeProfiler startRecord]; \n\nat the end,insert \n\n[DoraemonTimeProfiler stopRecord];\n\nThen manually operate the App to execute the code，You can see the complete function time-consuming analysis in the console。\n\nThe sdk filters the code call level> 10 layers, and the function call takes less than 1ms. Of course, you can also set it yourself through the api \n\nAfter analyzing, remember to delete the function call of startRecord and stopRecord.";

    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = [UIColor doraemon_black_2];
    _contentLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFromLandscape(24)];
    _contentLabel.numberOfLines = 0;
    [self.view addSubview:_contentLabel];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contet];
    NSRange range = [contet rangeOfString:@"[DoraemonTimeProfiler startRecord];"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    range = [contet rangeOfString:@"[DoraemonTimeProfiler stopRecord];"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    range = [contet rangeOfString:@"After the analysis is complete, remember to delete the startRecord and stopRecord function calls."];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    _contentLabel.attributedText = attrStr;

    CGSize fontSize = [_contentLabel sizeThatFits:CGSizeMake(self.view.doraemon_width - 40, MAXFLOAT)];
    _contentLabel.frame = CGRectMake(20, IPHONE_NAVIGATIONBAR_HEIGHT, fontSize.width, fontSize.height);
}

@end
