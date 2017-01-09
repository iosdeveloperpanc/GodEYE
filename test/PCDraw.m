//
//  PCDraw.m
//  test
//
//  Created by panchao on 16/12/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PCDraw.h"

@implementation PCDraw

+ (void)drawLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(UIColor *)color {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
    CGContextStrokePath(ctx);
}

+ (void)drawDashesLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(UIColor *)color {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    CGContextSetLineWidth(currentContext, 1);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    CGFloat arr[] = {3,1};
    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
}


@end
