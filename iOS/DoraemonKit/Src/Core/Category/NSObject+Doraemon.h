//
//  NSObject+Doraemon.h
//  DoraemonKit
//
//  Created by yixiang on 2018/7/2.
//

#import <Foundation/Foundation.h>

@interface NSObject (Doraemon)
+ (void)doraemon_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

+ (void)doraemon_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;
@end
