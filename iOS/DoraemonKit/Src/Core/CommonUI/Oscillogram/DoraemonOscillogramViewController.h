//
//  DoraemonOscillogramViewController.h
//  DoraemonKit
//
//  Created by yixiang on 2018/1/4.
//

#import "DoraemonOscillogramView.h"
#import <UIKit/UIKit.h>

@interface DoraemonOscillogramViewController : UIViewController
@property (nonatomic, strong) DoraemonOscillogramView *oscillogramView;

- (NSString *)title;
- (NSString *)lowValue;
- (NSString *)highValue;
- (void)startRecord;
- (void)endRecord;
- (void)doSecondFunction;
@end
