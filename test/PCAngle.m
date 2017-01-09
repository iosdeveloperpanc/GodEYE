//
//  PCAngle.m
//  test
//
//  Created by panchao on 16/12/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PCAngle.h"

@implementation PCAngle

+ (CGFloat)atanWithPointOne:(CGPoint)pointOne pointTwo:(CGPoint)pointTwo {
    return atan2(pointOne.y - pointTwo.y, pointOne.x - pointTwo.x);
}

+ (BOOL)angleIsInFirstOrFourthQuadrant:(CGFloat)angle {
    if ((angle >= M_PI_2 && angle <= M_PI) || (angle <= -M_PI_2 && angle >= -M_PI)) {
        return YES;
    }
    return NO;
}

@end
