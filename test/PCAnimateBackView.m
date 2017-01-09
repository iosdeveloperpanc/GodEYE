//
//  PCPersonBackView.m
//  test
//
//  Created by panchao on 16/12/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PCAnimateBackView.h"
#import "UIColor+category.h"

static CGFloat extraRadius = 22.0f;

@interface PCAnimateBackView()

@property (nonatomic, strong) CALayer *outAnimateLayer;
@property (nonatomic, strong) CALayer *inAnimateLayer;
@property (nonatomic, strong) CALayer *centerAnimateLayer;
@property (nonatomic, strong) CABasicAnimation *outAnimation;
@property (nonatomic, strong) CABasicAnimation *inAnimation;
@property (nonatomic, strong) CABasicAnimation *centerAnimation;

@end

@implementation PCAnimateBackView

- (void)setSizeWidth:(CGFloat)sizeWidth {
    _sizeWidth = sizeWidth;

    CGRect frame = self.frame;
    frame.size = CGSizeMake(sizeWidth, sizeWidth);
    self.frame = frame;
    self.layer.cornerRadius = sizeWidth/2;
    self.clipsToBounds = YES;
}

+ (instancetype)animateBackView {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.3;
    }
    return self;
}

- (CALayer *)outAnimateLayer {
    if (!_outAnimateLayer) {
        _outAnimateLayer = [CALayer layer];
        _outAnimateLayer.backgroundColor = [UIColor clearColor].CGColor;
        _outAnimateLayer.frame = self.bounds;
    }
    return _outAnimateLayer;
}

- (CALayer *)inAnimateLayer {
    if (!_inAnimateLayer) {
        _inAnimateLayer = [CALayer layer];
        _inAnimateLayer.backgroundColor = [UIColor clearColor].CGColor;
        _inAnimateLayer.frame = self.bounds;
    }
    return _inAnimateLayer;
}

- (CALayer *)centerAnimateLayer {
    if (!_centerAnimateLayer) {
        _centerAnimateLayer = [CALayer layer];
        _centerAnimateLayer.backgroundColor = [UIColor clearColor].CGColor;
        _centerAnimateLayer.frame = self.bounds;
    }
    return _centerAnimateLayer;
}

- (void)stopAnimation {
    self.animating = NO;

    [self.outAnimateLayer removeFromSuperlayer];
    [self.outAnimateLayer removeAllAnimations];

    [self.inAnimateLayer removeFromSuperlayer];
    [self.inAnimateLayer removeAllAnimations];

    [self.centerAnimateLayer removeFromSuperlayer];
    [self.centerAnimateLayer removeAllAnimations];
}

- (void)animate {

    if (self.isAnimating) {
        return;
    }

    [self.layer addSublayer:self.outAnimateLayer];
    [self.layer addSublayer:self.inAnimateLayer];
    [self.layer addSublayer:self.centerAnimateLayer];

    CGFloat wheelLength = 4.0f;
    CGFloat margin = 4.0f;
    CGFloat shadowWidth = 8.0f;
    CGFloat minRadius = self.sizeWidth/2 - extraRadius;
    CGFloat wheelMinRadius = minRadius + margin/2;
    CGFloat inCircleRadius = wheelMinRadius + + wheelLength + margin;
    CGFloat outCircleRadius = inCircleRadius + shadowWidth/2 +margin;

    NSLog(@"所需最大半径：%f", outCircleRadius + shadowWidth/2);

    // 3.齿轮部分
    CGFloat count = 60;
    CGFloat itemAngle = M_PI / count;
    for (int i = -count; i < count; i++) {
        CGFloat drawAngle = itemAngle * i;

        CGPoint center = CGPointMake(self.sizeWidth/2, self.sizeWidth/2);

        CGFloat bigRadius = wheelMinRadius + wheelLength;

        CGFloat dx1 = cos(drawAngle) * wheelMinRadius;
        CGFloat dy1 = sin(drawAngle) * wheelMinRadius;

        CGFloat dx2 = cos(drawAngle) * bigRadius;
        CGFloat dy2 = sin(drawAngle) * bigRadius;

        CGPoint pointOne = CGPointMake(center.x + dx1, center.y + dy1);
        CGPoint pointTwo = CGPointMake(center.x + dx2, center.y + dy2);

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = [UIColor themeMovingColor].CGColor;
        shapeLayer.lineCap = kCALineCapSquare;
        shapeLayer.lineWidth = 1;

        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:pointOne];
        [path addLineToPoint:pointTwo];
        shapeLayer.path = path.CGPath;

        [self.centerAnimateLayer addSublayer:shapeLayer];
        [self.centerAnimateLayer addAnimation:self.centerAnimation forKey:@"centerCircle"];
    }

    // 2.内环
    CGFloat marginAngle = M_PI/8;
    itemAngle = (M_PI * 2 - 4 * marginAngle)/4;
    for (NSInteger i = 0; i < 4; i++) {
        CGFloat startAngle = i * (marginAngle + itemAngle) + itemAngle/2;
        CGFloat endAngle = startAngle + itemAngle;

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor themeMovingColor].CGColor;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = 1;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.sizeWidth/2, self.sizeWidth/2) radius:inCircleRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        shapeLayer.path = path.CGPath;
        [self.inAnimateLayer addSublayer:shapeLayer];
        [self.inAnimateLayer addAnimation:self.inAnimation forKey:@"inCircle"];
    }

    // 1.外环
    for (NSInteger i = 0; i < 4; i++) {
        CGFloat startAngle = i * (marginAngle + itemAngle);
        CGFloat endAngle = startAngle + itemAngle;

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor themeMovingColor].CGColor;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = 2;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.sizeWidth/2, self.sizeWidth/2) radius:outCircleRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        shapeLayer.path = path.CGPath;
        [self.outAnimateLayer addSublayer:shapeLayer];
        [self.outAnimateLayer addAnimation:self.outAnimation forKey:@"outCircle"];
    }

    // 2.外环阴影
    for (NSInteger i = 0; i < 4; i++) {
        CGFloat startAngle = i * (marginAngle + itemAngle);
        CGFloat endAngle = startAngle + itemAngle;

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor outCircleShadowColor].CGColor;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = shadowWidth;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.sizeWidth/2, self.sizeWidth/2) radius:outCircleRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        shapeLayer.path = path.CGPath;
        [self.outAnimateLayer addSublayer:shapeLayer];
        [self.outAnimateLayer addAnimation:self.outAnimation forKey:@"outCircle"];
    }

    self.animating = YES;
}

- (CABasicAnimation *)outAnimation {
    if (!_outAnimation) {
        _outAnimation = [CABasicAnimation animation];
        _outAnimation.keyPath = @"transform.rotation.z";
        _outAnimation.duration = 1.5f;
        _outAnimation.fromValue = @(0);
        _outAnimation.toValue = @(-2*M_PI);
        _outAnimation.repeatCount = INFINITY;
    }
    return _outAnimation;
}

- (CABasicAnimation *)inAnimation {
    if (!_inAnimation) {
        _inAnimation = [CABasicAnimation animation];
        _inAnimation.keyPath = @"transform.rotation.z";
        _inAnimation.duration = 2.f;
        _inAnimation.fromValue = @(0);
        _inAnimation.toValue = @(2*M_PI);
        _inAnimation.repeatCount = INFINITY;
    }
    return _inAnimation;
}

- (CABasicAnimation *)centerAnimation {
    if (!_centerAnimation) {
        _centerAnimation = [CABasicAnimation animation];
        _centerAnimation.keyPath = @"transform.rotation.z";
        _centerAnimation.duration = 60.f;
        _centerAnimation.fromValue = @(0);
        _centerAnimation.toValue = @(-2*M_PI);
        _centerAnimation.repeatCount = INFINITY;
    }
    return _centerAnimation;
}


@end
