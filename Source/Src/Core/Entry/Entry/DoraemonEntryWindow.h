//
//  DoraemonEntryWindow.h
//  dokit
//
//  Created by yixiang on 2017/12/11.
//  Copyright © 2017 yixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoraemonEntryWindow : UIWindow
- (instancetype)initWithStartPoint:(CGPoint)startingPosition;
- (void)show;

- (void)configEntryBtnBlingWithText:(NSString *)text backColor:(UIColor *)backColor;
@end
