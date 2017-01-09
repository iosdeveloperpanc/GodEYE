//
//  PCPoint.m
//  test
//
//  Created by panchao on 16/12/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PCPoint.h"

@implementation PCPoint

+ (CGPoint)centerPointBetweenPointOne:(CGPoint)pointOne pointTwo:(CGPoint)pointTwo {
    return CGPointMake((pointOne.x + pointTwo.x)/2, (pointOne.y + pointTwo.y)/2);
}

+ (CGPoint)intersectionPointWithCircleCenterOne:(CGPoint)pointOne centerTwo:(CGPoint)pointTwo circleTwoRadius:(CGFloat)radius {
    CGFloat lineAtanAngle = atan2(pointOne.y - pointTwo.y, pointOne.x - pointTwo.x);
    CGFloat differX = radius * cos(lineAtanAngle);
    CGFloat differY = radius * sin(lineAtanAngle);
    CGPoint intersectionPoint = CGPointMake(pointTwo.x - differX - radius * 2 * cos(lineAtanAngle + M_PI), pointTwo.y - differY - radius * 2 * sin(lineAtanAngle + M_PI));
    return intersectionPoint;
}

+ (NSArray *)pointsOfArrowWithPointOne:(CGPoint)pointOne
                              pointTwo:(CGPoint)pointTwo
                           drawAtPoint:(CGPoint)intersectionPoint
                           slideLength:(CGFloat)length
                              topAngle:(CGFloat)topAngle {

    CGFloat atanAngle = atan2(pointOne.y - pointTwo.y, pointTwo.x - pointOne.x);
    // 求一个点
    CGFloat dx1 = intersectionPoint.x + length * sin(atanAngle - (M_PI - topAngle)/2);
    CGFloat dy1 = intersectionPoint.y + length * cos(atanAngle - (M_PI - topAngle)/2);

    // 求另一个点
    CGFloat dx2 = intersectionPoint.x - length * cos(M_PI_2 - (M_PI - topAngle)/2 - atanAngle);
    CGFloat dy2 = intersectionPoint.y - length * sin(M_PI_2 - (M_PI - topAngle)/2 - atanAngle);

    NSValue *point1 = [NSValue valueWithCGPoint:CGPointMake(dx1, dy1)];
    NSValue *point2 = [NSValue valueWithCGPoint:CGPointMake(dx2, dy2)];
    return @[point1, point2];
}

+ (BOOL)containPoint:(CGPoint)point inRect:(CGRect)frame {
    BOOL containX = (point.x > frame.origin.x) && (point.x < (frame.origin.x + frame.size.width));
    BOOL containY = (point.y > frame.origin.y) && (point.y < (frame.origin.y + frame.size.height));

    if (containX && containY) {
        return YES;
    }
    return NO;
}

@end
