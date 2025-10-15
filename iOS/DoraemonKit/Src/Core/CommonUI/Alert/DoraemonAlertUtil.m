//
//  DoraemonAlertUtil.m
//  DoraemonKit
//
//  Created by didi on 2019/8/27.
//

#import "DoraemonAlertUtil.h"

@implementation DoraemonAlertUtil
+ (void)handleAlertActionWithVC:(UIViewController *)vc
                        okBlock:(DoraemonAlertOKActionBlock)okBlock
                    cancleBlock:(DoraemonAlertCancleActionBlock)cancleBlock {
    [self handleAlertActionWithVC:vc text:@"Reboot to work" okBlock:okBlock cancleBlock:cancleBlock];
}

+ (void)handleAlertActionWithVC:(UIViewController *)vc
                           text:(NSString *)text
                        okBlock:(DoraemonAlertOKActionBlock)okBlock
                    cancleBlock:(DoraemonAlertCancleActionBlock)cancleBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tip" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                             cancleBlock ? cancleBlock() : nil;
                                                         }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                         okBlock ? okBlock() : nil;
                                                     }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}

+ (void)handleAlertActionWithVC:(UIViewController *)vc
                           text:(NSString *)text
                        okBlock:(DoraemonAlertOKActionBlock)okBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tip" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                         okBlock ? okBlock() : nil;
                                                     }];
    [alertController addAction:okAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}

+ (void)handleAlertActionWithVC:(UIViewController *)vc
                          title:(NSString *)title
                           text:(NSString *)text
                             ok:(NSString *)ok
                        okBlock:(DoraemonAlertOKActionBlock)okBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                         okBlock ? okBlock() : nil;
                                                     }];
    [alertController addAction:okAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}

+ (void)handleAlertActionWithVC:(UIViewController *)vc
                          title:(NSString *)title
                           text:(NSString *)text
                             ok:(NSString *)ok
                         cancel:(NSString *)cancel
                        okBlock:(DoraemonAlertOKActionBlock)okBlock
                    cancleBlock:(DoraemonAlertCancleActionBlock)cancleBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                             cancleBlock ? cancleBlock() : nil;
                                                         }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                         okBlock ? okBlock() : nil;
                                                     }];

    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}
@end
