//
//  DoraemonColorPickMagnifyLayer.h
//  DoraemonKit
//
//  Created by wenquan on 2019/1/31.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN
typedef NSString* _Nullable (^DoraemonColorPickMagnifyLayerPointColorBlock) (CGPoint point);

@interface DoraemonColorPickMagnifyLayer : CALayer
@property (nonatomic, copy) DoraemonColorPickMagnifyLayerPointColorBlock pointColorBlock;

@property (nonatomic, assign) CGPoint targetPoint;
@end

NS_ASSUME_NONNULL_END
