//
//  PCLabel.m
//  test
//
//  Created by panchao on 16/12/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PCLabel.h"
#import "UIColor+category.h"

@implementation PCLabel

+ (instancetype)labelWithText:(NSString *)text center:(CGPoint)center {
    return [[self alloc] initWithText:text center:center];
}

- (instancetype)initWithText:(NSString *)text center:(CGPoint)center {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.text = text;
        self.textColor = [UIColor themeNormalColor];
        self.font = [UIFont systemFontOfSize:10];
        NSDictionary *attributes = @{ NSFontAttributeName : self.font };
        CGSize size = [self.text sizeWithAttributes:attributes];
        self.frame = CGRectMake(center.x - size.width/2, center.y - size.height/2, size.width, size.height);
    }
    return self;
}

- (void)setRotationAngle:(CGFloat)rotationAngle {
    _rotationAngle = rotationAngle;

    // rotation
    CGAffineTransform transform = self.transform;
    transform = CGAffineTransformIdentity;
    self.transform = transform;
    transform = CGAffineTransformMakeRotation(rotationAngle);
    self.transform = transform;
}

@end
