//
//  PCBaseView.h
//  test
//
//  Created by panchao on 16/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+category.h"
#import "PCItem.h"


typedef NS_ENUM(NSInteger, PanGestureState) {
    PanGestureStateEnded,
    PanGestureStateMoving
};

typedef NS_ENUM(NSInteger, PCBaseViewType) {
    PCBaseViewTypeUserAdded,
    PCBaseViewTypeSystemAdded
};

@interface PCBaseView : UIButton

@property (nonatomic, strong) PCItem *item;
@property (nonatomic, assign) CGFloat sizeWidth;
@property (nonatomic, assign) PanGestureState panState;
@property (nonatomic, assign) CGFloat extraRadius;
@property (nonatomic, assign) PCBaseViewType *type;
@property (nonatomic, copy) void(^panGestureMoving)(PCBaseView *);
@property (nonatomic, copy) void(^panGestureEnded)();

+ (instancetype)viewWithItem:(PCItem *)item;
- (instancetype)initWithItem:(PCItem *)item;

@end
