//
//  PCDraw.h
//  test
//
//  Created by panchao on 16/12/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCDraw : NSObject

// draw 实线
+ (void)drawLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(UIColor *)color;

// draw 虚线
+ (void)drawDashesLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(UIColor *)color;

@end
