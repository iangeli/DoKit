//
//  UIColor+Doraemon.h
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//

#import <UIKit/UIKit.h>

@interface UIColor (Doraemon)
@property (nonatomic, readonly) CGFloat red; 
@property (nonatomic, readonly) CGFloat green; 
@property (nonatomic, readonly) CGFloat blue; 
@property (nonatomic, readonly) CGFloat white; 
@property (nonatomic, readonly) CGFloat alpha;

+ (UIColor *)doraemon_colorWithHex:(UInt32)hex;
+ (UIColor *)doraemon_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)doraemon_colorWithHexString:(NSString *)hexString;

+ (UIColor *)doraemon_colorWithString:(NSString *)hexString;

+ (UIColor *)doraemon_black_1;
+ (UIColor *)doraemon_black_2;
+ (UIColor *)doraemon_black_3;

+ (UIColor *)doraemon_blue;

+ (UIColor *)doraemon_line;

+ (UIColor *)doraemon_randomColor;

+ (UIColor *)doraemon_bg; 

+ (UIColor *)doraemon_orange; 
@end
