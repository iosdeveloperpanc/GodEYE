//
//  PCBaseView.m
//  test
//
//  Created by panchao on 16/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PCBaseView.h"
#import "PCItem.h"
#import "UIColor+category.h"

@implementation PCBaseView

- (void)setItem:(PCItem *)item {
    _item = item;

    [self setTitle:item.name forState:UIControlStateNormal];
}

+ (instancetype)viewWithItem:(PCItem *)item {
    return [[self alloc] initWithItem:item];
}

- (instancetype)initWithItem:(PCItem *)item {
    if (self = [super init]) {
        self.item = item;
        [self configuration];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configuration];
    }
    return self;
}

- (void)configuration {
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    // 加pan手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handPanGesture:)];
    [self addGestureRecognizer:pan];

    // 监听sizeWidth
    [self addObserver:self forKeyPath:@"sizeWidth" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];

    self.panState = PanGestureStateEnded;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([change[NSKeyValueChangeOldKey] isEqual:change[NSKeyValueChangeNewKey]]) {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(self.sizeWidth, self.sizeWidth);
        self.frame = frame;
        self.layer.cornerRadius = self.sizeWidth/2;
        self.clipsToBounds = YES;
        return;
    }

    CGRect frame = self.frame;
    frame.size = CGSizeMake(self.sizeWidth, self.sizeWidth);
    self.frame = frame;
    self.layer.cornerRadius = self.sizeWidth/2;
    self.clipsToBounds = YES;

    if (self.item.isSystemAdded) {
        [self setBackgroundImage:[UIImage ImageWithColor:[UIColor systemAddedColor] drawInRect:self.bounds] forState:UIControlStateNormal];
    } else {
        [self setBackgroundImage:[UIImage ImageWithColor:[UIColor themeNormalColor] drawInRect:self.bounds] forState:UIControlStateNormal];
    }

    [self setBackgroundImage:[UIImage ImageWithColor:[UIColor themeDisableColor] drawInRect:self.bounds] forState:UIControlStateDisabled];
}

- (void)handPanGesture:(UIPanGestureRecognizer *)gesture {

    CGPoint location = [gesture locationInView:gesture.view.superview];

    CGFloat horizonMin = self.sizeWidth/2 + self.extraRadius;
    CGFloat horizonMax = self.superview.frame.size.width - self.sizeWidth/2 - self.extraRadius;
    CGFloat verticalMin = self.sizeWidth/2 + self.extraRadius;
    CGFloat verticalMax = self.superview.frame.size.height - self.sizeWidth/2 - self.extraRadius;

    if (location.x < horizonMin) {
        location.x = horizonMin;
    } else if (location.x > horizonMax) {
        location.x = horizonMax;
    }

    if (location.y < verticalMin) {
        location.y = verticalMin;
    } else if (location.y > verticalMax) {
        location.y = verticalMax;
    }

    if (gesture.state == UIGestureRecognizerStateEnded) {
        gesture.view.center = location;
        self.panState = PanGestureStateEnded;
        
        if (self.panGestureEnded) {
            self.panGestureEnded();
        }
    } else {
        gesture.view.center = location;
        self.panState = PanGestureStateMoving;

        [self setBackgroundImage:[UIImage ImageWithColor:[UIColor themeMovingColor] drawInRect:self.bounds] forState:UIControlStateNormal];

        if (self.panGestureMoving) {
            self.panGestureMoving(self);
        }
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {

    CGFloat x = 8;
    CGFloat y = 8;
    CGFloat width = self.sizeWidth - 2*x;
    CGFloat height = self.sizeWidth - 2*y;
    return CGRectMake(x, y, width, height);

}

@end
