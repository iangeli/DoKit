//
//  DoraemonDeleteLocalDataViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2018/11/22.
//

#import "DoraemonDeleteLocalDataViewController.h"
#import "DoraemonCellButton.h"
#import "DoraemonDefine.h"
#import "DoraemonUtil.h"

@interface DoraemonDeleteLocalDataViewController ()<DoraemonCellButtonDelegate>
@property (nonatomic, strong) DoraemonCellButton *cellBtn;
@end

@implementation DoraemonDeleteLocalDataViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Clear Sanbox";

    _cellBtn = [[DoraemonCellButton alloc] initWithFrame:CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT, self.view.doraemon_width, kDoraemonSizeFromLandscape(104))];
    [_cellBtn renderUIWithTitle:@"Clear Sanbox"];
    [_cellBtn renderUIWithRightContent:[self getHomeDirFileSize]];
    _cellBtn.delegate = self;
    [_cellBtn needDownLine];
    [self.view addSubview:_cellBtn];
}

- (void)cellBtnClick:(id)sender {
    [self deleteFile];
}

- (void)deleteFile {

    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tip" message:@"Confirm to clear sanbox data" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                         [weakSelf.cellBtn renderUIWithRightContent:@"Deleting"];
                                                         [DoraemonUtil clearLocalDatas];
                                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                             [weakSelf.cellBtn renderUIWithRightContent:[self getHomeDirFileSize]];
                                                         });
                                                     }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)getHomeDirFileSize {

    NSString *homeDir = NSHomeDirectory();

    DoraemonUtil *util = [[DoraemonUtil alloc] init];
    [util getFileSizeWithPath:homeDir];
    NSInteger fileSize = util.fileSize;
    NSString *fileSizeString = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
    return fileSizeString;
}
@end
