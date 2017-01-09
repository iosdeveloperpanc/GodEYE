//
//  PCAngle.h
//  test
//
//  Created by panchao on 16/12/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCAngle : NSObject

/** 两个点连线的arctan正切弧度制角度 */
+ (CGFloat)atanWithPointOne:(CGPoint)pointOne pointTwo:(CGPoint)pointTwo;

/** 判断一个弧度是否属于一四象限 */
+ (BOOL)angleIsInFirstOrFourthQuadrant:(CGFloat)angle;

@end
