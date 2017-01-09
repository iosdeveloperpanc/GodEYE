//
//  UIColor+category.m
//  test
//
//  Created by panchao on 17/1/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#define drawColor(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

#import "UIColor+category.h"

@implementation UIColor (category)

+ (instancetype)themeNormalColor {
    return drawColor(97, 113, 252, 1);
}

+ (instancetype)themeMovingColor {
    return drawColor(27, 171, 180, 1);
}

+ (instancetype)themeDisableColor {
    return [UIColor lightGrayColor];
}

+ (instancetype)systemAddedColor {
    return drawColor(0, 230, 175, 1);
}

+ (instancetype)outCircleShadowColor {
    return drawColor(27, 171, 180, 0.2);
}

@end
