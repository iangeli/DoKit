//
//  DoraemonQRCodeViewController.h
//  DoraemonKit
//
//  Created by love on 2019/5/22.
//

#import "DoraemonBaseViewController.h"
#import <Foundation/Foundation.h>

@interface DoraemonQRCodeViewController : DoraemonBaseViewController
@property (nonatomic, copy) void (^QRCodeBlock)(NSString *QRCodeResult);
@end
