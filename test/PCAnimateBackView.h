//
//  PCAnimateBackView.h
//  test
//
//  Created by panchao on 16/12/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCAnimateBackView : UIView

@property (nonatomic, assign) CGFloat sizeWidth;
@property (nonatomic, assign, getter=isAnimating) BOOL animating;

+ (instancetype)animateBackView;

- (void)animate;
- (void)stopAnimation;

@end
