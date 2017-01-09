//
//  PCRelationView.h
//  test
//
//  Created by panchao on 16/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCRelationData;

typedef NS_ENUM(NSInteger, PCViewState) {
    PCViewStateEnded,
    PCViewStateMoving
};

@interface PCRelationView : UIView

@property (nonatomic, strong) PCRelationData *data;
@property (nonatomic, assign) PCViewState state;
@property (nonatomic, assign) BOOL hiddenRelationShip;

+ (instancetype)customViewWithFrame:(CGRect)frame relationData:(PCRelationData *)data;
- (instancetype)initWithFrame:(CGRect)frame relationData:(PCRelationData *)data;

@end
