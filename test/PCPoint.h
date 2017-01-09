//
//  PCPoint.h
//  test
//
//  Created by panchao on 16/12/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCPoint : NSObject

/** 求2个点的中点 */
+ (CGPoint)centerPointBetweenPointOne:(CGPoint)pointOne pointTwo:(CGPoint)pointTwo;

/** 两个空心圆，圆心连线，线与第二个圆的交点 */
+ (CGPoint)intersectionPointWithCircleCenterOne:(CGPoint)pointOne
                                      centerTwo:(CGPoint)pointTwo
                                circleTwoRadius:(CGFloat)radius;

/** 返回两个边点数组，在两点连线的一端绘制已知角度、腰长、两端点坐标，求其它2个边点坐标 */
+ (NSArray *)pointsOfArrowWithPointOne:(CGPoint)pointOne
                              pointTwo:(CGPoint)pointTwo
                           drawAtPoint:(CGPoint)intersectionPoint
                           slideLength:(CGFloat)length
                              topAngle:(CGFloat)topAngle;

/** 判断一个点在不在一个区域内 */
+ (BOOL)containPoint:(CGPoint)point inRect:(CGRect)frame;

@end
