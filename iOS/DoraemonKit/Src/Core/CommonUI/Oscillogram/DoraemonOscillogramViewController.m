//
//  DoraemonOscillogramViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2018/1/4.
//

#import "DoraemonOscillogramViewController.h"
#import "DoraemonOscillogramWindowManager.h"
#import "DoraemonDefine.h"

@interface DoraemonOscillogramViewController ()
@property (nonatomic, strong) NSTimer *secondTimer;
@end

@implementation DoraemonOscillogramViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [self title];
    titleLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFromLandscape(20)];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(kDoraemonSizeFromLandscape(20), kDoraemonSizeFromLandscape(10), titleLabel.doraemon_width, titleLabel.doraemon_height);

    _oscillogramView = [[DoraemonOscillogramView alloc] initWithFrame:CGRectMake(0, titleLabel.doraemon_bottom, CGRectGetWidth(self.view.frame), 60 - titleLabel.doraemon_bottom)];
    _oscillogramView.backgroundColor = [UIColor clearColor];
    [_oscillogramView setLowValue:[self lowValue]];
    [_oscillogramView setHightValue:[self highValue]];
    [self.view addSubview:_oscillogramView];
}

- (NSString *)title{
    return @"";
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return @"100";
}

- (void)startRecord{
    if(!_secondTimer){
        _secondTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(doSecondFunction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_secondTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)doSecondFunction{
    
}

- (void)endRecord{
    if(_secondTimer){
        [_secondTimer invalidate];
        _secondTimer = nil;
        [self.oscillogramView clear];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[DoraemonOscillogramWindowManager shareInstance] resetLayout];
    });
}
@end
