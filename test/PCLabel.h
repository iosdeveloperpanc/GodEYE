//
//  PCLabel.h
//  test
//
//  Created by panchao on 16/12/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCLabel : UILabel

@property (nonatomic, assign) CGFloat rotationAngle;

+ (instancetype)labelWithText:(NSString *)text center:(CGPoint)center;
- (instancetype)initWithText:(NSString *)text center:(CGPoint)center;

@end
