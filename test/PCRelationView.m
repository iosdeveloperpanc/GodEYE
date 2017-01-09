//
//  PCRelationView.m
//  test
//
//  Created by panchao on 16/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#define ARROW_TOP_ANGLE M_PI_2/3
#define ARROW_SLIDELENGTH 8

#import "PCRelationView.h"
#import "PCRelationData.h"
#import "PCPerson.h"
#import "PCCompany.h"
#import "PCBaseView.h"
#import "PCPersonView.h"
#import "PCCompanyView.h"
#import "PCDraw.h"
#import "PCPoint.h"
#import "PCAngle.h"
#import "PCLabel.h"
#import "PCAnimateBackView.h"
#import "PCRelationShip.h"
#import "UIColor+category.h"

@interface PCRelationView()

@property (nonatomic, strong) NSMutableArray<PCBaseView *> *relationViews;
@property (nonatomic, strong) NSMutableArray<PCLabel *> *labels;
@property (nonatomic, strong) NSMutableArray<PCRelationShip *> *relationShips;
@property (nonatomic, strong) NSMutableArray<PCLabel *> *showLabels;
@property (nonatomic, strong) PCBaseView *currentItemView;
@property (nonatomic, strong) PCAnimateBackView *animateBackView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) BOOL labelsHasCreated;

@end

@implementation PCRelationView

- (void)setHiddenRelationShip:(BOOL)hiddenRelationShip {
    _hiddenRelationShip = hiddenRelationShip;

    [self setNeedsDisplay];
}

- (NSMutableArray *)relationViews {
    if (!_relationViews) {
        _relationViews = [NSMutableArray array];
    }
    return _relationViews;
}

- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

- (NSMutableArray *)showLabels {
    if (!_showLabels) {
        _showLabels = [NSMutableArray array];
    }
    return _showLabels;
}

- (NSMutableArray<PCRelationShip *> *)relationShips {
    if (!_relationShips) {
        _relationShips = [NSMutableArray array];
    }
    return _relationShips;
}

- (PCAnimateBackView *)animateBackView {
    if (!_animateBackView) {
        _animateBackView = [PCAnimateBackView animateBackView];
        _animateBackView.sizeWidth = self.currentItemView.sizeWidth + self.currentItemView.extraRadius * 2;
        _animateBackView.center = self.currentItemView.center;

        // 动起来
        [_animateBackView animate];
    }
    return _animateBackView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        [_maskView setBackgroundColor:[UIColor whiteColor]];
        _maskView.alpha = 0.5;
    }
    return _maskView;
}

- (void)drawRect:(CGRect)rect {

    for (NSInteger i = 0; i < self.relationViews.count; i++) {

        PCBaseView *startView = self.relationViews[i];
        PCBaseView *endView;

        // 和下级连线
        for (PCItem *item in startView.item.subordinates) {
            // 找到下级的itemView
            for (NSInteger j = i+1; j < self.relationViews.count; j++) {
                PCBaseView *subordinateView = self.relationViews[j];
                if ([item isEqual:subordinateView.item]) {
                    endView = subordinateView;
                    break;
                } else {
                    endView = nil;
                }
            }

            if (endView && ![startView isEqual:endView]) {

                // 取出起点和终点（两个圆心）
                CGPoint startPoint = startView.center;
                CGPoint endPoint = endView.center;

                // 计算圆心连线与圆的交点（两个交点）
                CGPoint endIntersectionPoint = [PCPoint intersectionPointWithCircleCenterOne:startPoint centerTwo:endPoint circleTwoRadius:endView.sizeWidth/2];
                CGPoint startIntersectionPoint = [PCPoint intersectionPointWithCircleCenterOne:endPoint centerTwo:startPoint circleTwoRadius:startView.sizeWidth/2];

                // 拖拽时颜色设置
                UIColor *drawColor;
                if (self.state == PCViewStateMoving) {

                    PCRelationShip *currentShip;
                    for (PCRelationShip *ship in self.relationShips) {
                        BOOL startViewRelative = [startView.item isEqual:ship.startItem];
                        BOOL endViewRelative = [endView.item isEqual:ship.endItem];
                        BOOL relative = startViewRelative && endViewRelative;
                        if (relative) {
                            currentShip = ship;
                        }
                    }

                    if ([self.currentItemView.item isEqual:currentShip.startItem] || [self.currentItemView.item isEqual:currentShip.endItem]) {
                        drawColor = [UIColor themeMovingColor];
                    } else {
                        drawColor = [UIColor themeDisableColor];
                    }
                } else {
                    drawColor = [UIColor themeNormalColor];
                }

                // 找到连线中点
                CGPoint lineCenter = [PCPoint centerPointBetweenPointOne:startIntersectionPoint pointTwo:endIntersectionPoint];

                // 绘制箭头 两个视图没有交点才展示箭头
                CGFloat centerDistance = sqrt(pow(startPoint.x - endPoint.x, 2) + pow(startPoint.y - endPoint.y, 2));
                CGFloat lineLength = sqrt(pow(startIntersectionPoint.x - endIntersectionPoint.x, 2) + pow(startIntersectionPoint.y - endIntersectionPoint.y, 2));

                BOOL noIntersection = centerDistance > (startView.sizeWidth/2 + endView.sizeWidth/2);
                BOOL draw = noIntersection ? YES : NO;
                if (draw) {
                    // 绘制箭头
                    CGFloat arrowSlideLength = lineLength < ARROW_SLIDELENGTH ? lineLength : ARROW_SLIDELENGTH;
                    NSArray *points = [PCPoint pointsOfArrowWithPointOne:startPoint pointTwo:endPoint drawAtPoint:endIntersectionPoint slideLength:arrowSlideLength topAngle:ARROW_TOP_ANGLE];

                    if (self.hiddenRelationShip) {
                        [PCDraw drawDashesLineWithStartPoint:startIntersectionPoint endPoint:endIntersectionPoint color:drawColor];
                    } else {
                        [PCDraw drawLineWithStartPoint:startIntersectionPoint endPoint:endIntersectionPoint color:drawColor];
                        [PCDraw drawLineWithStartPoint:endIntersectionPoint endPoint:[points.firstObject CGPointValue] color:drawColor];
                        [PCDraw drawLineWithStartPoint:endIntersectionPoint endPoint:[points.lastObject CGPointValue] color:drawColor];
                    }
                }

                // 关系描述label
                PCLabel *label = [PCLabel new];

                if (self.labelsHasCreated) {
                    // 关键是要找到那个label, 那么就应该找到对应的endView的index
                    NSInteger index = 0;
                    for (PCRelationShip *ship in self.relationShips) {
                        if ([ship.startItem isEqual:startView.item] && [ship.endItem isEqual:endView.item]) {
                            index = [self.relationShips indexOfObject:ship];
                        }
                    }
                    label = self.labels[index];
                    label.center = lineCenter;
                    NSLog(@"-----%@", label.text);

                } else {

                    // 创建label得放到这里，只有这个时候能知道人员之间的关系
                    NSString *text;
                    for (PCRelationShip *ship in startView.item.relationSHips) { // 一对多的关系实现
                        if ([ship.startItem isEqual:startView.item] && [ship.endItem isEqual:endView.item]) {
                            text = ship.shipName;
                            [self.relationShips addObject:ship];
                            break;
                        }
                    }

                    label = [PCLabel labelWithText:text center:lineCenter];
                    [self addSubview:label];
                    [self.labels addObject:label];
                    NSLog(@"===%@", label.text);
                }

                // 计算label应该旋转的角度 - 二、三象限与一、四象限切换时文字反转效果实现
                CGFloat lineAtanAngle = [PCAngle atanWithPointOne:startPoint pointTwo:endPoint];
                CGFloat labelAngle = [PCAngle angleIsInFirstOrFourthQuadrant:lineAtanAngle] ? (lineAtanAngle + M_PI) : lineAtanAngle;
                label.rotationAngle = labelAngle;

                // 1.相距距离 2.运动过程中关联的label展示 不关联的label隐藏
                BOOL distanceHidden = (centerDistance - startView.sizeWidth/2 - endView.sizeWidth/2) >= (label.frame.size.width + self.currentItemView.extraRadius * 2) ? NO : YES;
                BOOL movingHidden = (self.state == PCViewStateMoving ) && ![self.showLabels containsObject:label];
                label.hidden = distanceHidden || movingHidden || self.hiddenRelationShip;
            }
        }
    }

    self.labelsHasCreated = YES;
}

+ (instancetype)customViewWithFrame:(CGRect)frame relationData:(PCRelationData *)data {
    return [[self alloc] initWithFrame:frame relationData:data];
}

- (instancetype)initWithFrame:(CGRect)frame relationData:(PCRelationData *)data {
    if(self = [super initWithFrame:frame]) {
        [self configuration];
        self.data = data;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configuration];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configuration];
    }
    return self;
}

- (void)configuration {
    [self setBackgroundColor:[UIColor whiteColor]];

    // 添加监听者
    [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    [self setNeedsDisplay];

    if ([change[NSKeyValueChangeOldKey] isEqual:change[NSKeyValueChangeNewKey]]) {
        self.animateBackView.center = self.currentItemView.center;
        return;
    }

    // 背景图
    if (self.state == PCViewStateEnded) {
        // 蒙版移除
//        [self.maskView removeFromSuperview];
//        self.maskView = nil;
        // 背景动画视图移除
        [self.animateBackView removeFromSuperview];
        self.animateBackView = nil;

    } else {

        // 蒙版添加
//        [self addSubview:self.maskView];
//        for (PCBaseView *itemView in self.relationViews) {
//            if ([self.currentItemView.item.relativeItems containsObject:itemView.item]) {
//                [self bringSubviewToFront:itemView];
//            }
//        }

        // 背景动画视图添加
        [self addSubview:self.animateBackView];
        [self bringSubviewToFront:self.animateBackView];
        [self bringSubviewToFront:self.currentItemView];
    }

    for (PCBaseView *view in self.relationViews) {

        if (self.state == PCViewStateMoving) {

            // 将和当前操作视图没关联的全部disable
            BOOL relative = [self.currentItemView.item relativeWithOther:view.item];
            view.enabled = relative;
            view.alpha = relative ? 1 : 0.5;
            view.userInteractionEnabled = (view == self.currentItemView);

        } else if (self.state == PCViewStateEnded) {
            // 全部启用
            view.enabled = YES;
            view.alpha = 1;
            view.userInteractionEnabled = YES;
        }
    }

    for (PCRelationShip *ship in self.relationShips) {
        NSInteger index = [self.relationShips indexOfObject:ship];
        PCLabel *label = self.labels[index];

        if (self.state == PCViewStateMoving) {
            BOOL startViewRelative = [self.currentItemView.item isEqual:ship.startItem];
            BOOL endViewRelative = [self.currentItemView.item isEqual:ship.endItem];
            BOOL relative = startViewRelative || endViewRelative;
            label.textColor = relative ? [UIColor themeMovingColor] : [UIColor themeDisableColor];

            // 将label也置顶
            if (relative) {
                [self bringSubviewToFront:label];

                // 添加到展示的数组中
                [self.showLabels addObject:label];
            }
        } else {
            label.textColor = [UIColor themeNormalColor];

            // 清空展示的数组
            [self.showLabels removeAllObjects];
        }
    }
}

- (void)setData:(PCRelationData *)data {
    _data = data;

    [self configureSubviewsWithRelationData:data];

    [self setNeedsDisplay];
}

- (void)configureSubviewsWithRelationData:(PCRelationData *)data {

    NSMutableArray *personViews = [NSMutableArray array];
    NSMutableArray *companyViews = [NSMutableArray array];

    for (NSInteger i = 0; i < data.items.count; i++) {

        PCItem *item = data.items[i];
        PCBaseView *view;
        if ([item isKindOfClass:[PCPerson class]]) {
            view = [PCPersonView viewWithItem:item];
            [personViews addObject:view];
        } else if ([item isKindOfClass:[PCCompany class]]) {
            view = [PCCompanyView viewWithItem:item];
            [companyViews addObject:view];
        }

        [self addSubview:view];

        // ----- 不重合的frame计算 -----

        // 随机x 和 y
        NSInteger x = arc4random_uniform(self.frame.size.width);
        NSInteger y = arc4random_uniform(self.frame.size.height);

        while (x < view.sizeWidth || x > self.frame.size.width - view.sizeWidth) {
            x = arc4random_uniform(self.frame.size.width);
        }

        while (y < view.sizeWidth || y > self.frame.size.height - view.sizeWidth) {
            y = arc4random_uniform(self.frame.size.height);
        }

        CGRect frame = view.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        view.frame = frame;

        [self.relationViews addObject:view];

        __weak typeof(view) weakView = view;
        weakView.panGestureMoving = ^(PCBaseView *itemView){
            self.currentItemView = itemView;
            self.state = PCViewStateMoving;
        };
        
        weakView.panGestureEnded = ^{
            self.currentItemView = nil;
            self.state = PCViewStateEnded;
        };
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"state"];
}

@end

