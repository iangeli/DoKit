//
//  DoraemonColorPickMagnifyLayer.m
//  DoraemonKit
//
//  Created by wenquan on 2019/1/31.
//

#import "DoraemonColorPickMagnifyLayer.h"
#import <DoraemonKit/UIColor+Doraemon.h>

static CGFloat const kMagnifySize = 150; 
static CGFloat const kRimThickness = 3.0; 
static NSInteger const kGridNum = 15; 
static NSInteger const kPixelSkip = 1; 

@interface DoraemonColorPickMagnifyLayer ()
@property (nonatomic) struct CGPath *gridCirclePath;
@end

@implementation DoraemonColorPickMagnifyLayer
#pragma mark - Lifecycle

- (void)dealloc {
    if (_gridCirclePath) CGPathRelease(_gridCirclePath);
}

- (id)init {
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(-kMagnifySize/2, -kMagnifySize/2, kMagnifySize, kMagnifySize);
        self.anchorPoint = CGPointMake(0.5, 1);
        
        UIImage *magnifyImage = [self magnifyImage];
        CALayer *magnifyLayer = [CALayer layer];
        magnifyLayer.bounds = self.bounds;
        magnifyLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        magnifyLayer.contents = (id)magnifyImage.CGImage;
        magnifyLayer.magnificationFilter = kCAFilterNearest;
        [self addSublayer:magnifyLayer];
    }
    return self;
}

#pragma mark - Override

- (void)drawInContext:(CGContextRef)ctx {
    
    CGContextAddPath(ctx, self.gridCirclePath);
    CGContextClip(ctx);
    
    [self drawGridInContext:ctx];
}

- (void)drawGridInContext:(CGContextRef)ctx {
    CGFloat gridSize = ceilf(kMagnifySize/kGridNum);

    CGPoint currentPoint = self.targetPoint;
    currentPoint.x -= kGridNum*kPixelSkip/2;
    currentPoint.y -= kGridNum*kPixelSkip/2;
    NSInteger i,j;

    for (j=0; j<kGridNum; j++) {
        for (i=0; i<kGridNum; i++) {
            CGRect gridRect = CGRectMake(gridSize*i-kMagnifySize/2, gridSize*j-kMagnifySize/2, gridSize, gridSize);
            UIColor *gridColor = [UIColor clearColor];
            if (self.pointColorBlock) {
                NSString *pointColorHexString = self.pointColorBlock(currentPoint);
                gridColor = [UIColor doraemon_colorWithHexString:pointColorHexString];
            }
            CGContextSetFillColorWithColor(ctx, gridColor.CGColor);
            CGContextFillRect(ctx, gridRect);
            
            currentPoint.x += kPixelSkip;
        }
        
        currentPoint.x -= kGridNum*kPixelSkip;
        currentPoint.y += kPixelSkip;
    }
}

#pragma mark - Private

- (UIImage *)magnifyImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat size = kMagnifySize;
    CGContextTranslateCTM(ctx, size/2, size/2);

    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, self.gridCirclePath);
    CGContextClip(ctx);
    CGContextRestoreGState(ctx);

    CGContextSetLineWidth(ctx, kRimThickness);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextAddPath(ctx, self.gridCirclePath);
    CGContextStrokePath(ctx);

    CGContextSetLineWidth(ctx, kRimThickness-1);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextAddPath(ctx, self.gridCirclePath);
    CGContextStrokePath(ctx);

    CGFloat gridWidth = ceilf(kMagnifySize/kGridNum);
    CGFloat xyOffset = -(gridWidth+1)/2;
    CGRect selectedRect = CGRectMake(xyOffset, xyOffset, gridWidth, gridWidth);
    CGContextAddRect(ctx, selectedRect);

        UIColor *dyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return [UIColor blackColor];
            }
            else {
                return [UIColor whiteColor];
            }
        }];
        CGContextSetStrokeColorWithColor(ctx, dyColor.CGColor);
  
    CGContextSetLineWidth(ctx, 1.0);
    CGContextStrokePath(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Getter

- (struct CGPath *)gridCirclePath {
    if (_gridCirclePath == NULL) {
        CGMutablePathRef circlePath = CGPathCreateMutable();
        const CGFloat radius = kMagnifySize/2;
        CGPathAddArc(circlePath, nil, 0, 0, radius-kRimThickness/2, 0, 2*M_PI, YES);
        _gridCirclePath = circlePath;
    }
    return _gridCirclePath;
}
@end
