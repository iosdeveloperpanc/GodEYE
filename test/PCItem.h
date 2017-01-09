//
//  PCItem.h
//  test
//
//  Created by panchao on 16/12/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCRelationShip;

@interface PCItem : NSObject

@property (nonatomic, copy, readonly) NSString *uuid; // 用户唯一标识
@property (nonatomic, copy) NSString *name; // 姓名
@property (nonatomic, strong) NSMutableArray<PCItem *> *superiors; // 上级领导数组
@property (nonatomic, strong, readonly) NSMutableArray<PCItem *> *subordinates; // 下属员工数组
@property (nonatomic, strong, readonly) NSArray<PCItem *> *relativeItems;
@property (nonatomic, assign, getter=isSystemAdded) BOOL systemAdded;
@property (nonatomic, strong) NSMutableArray<PCRelationShip *> *relationSHips; // 关系数组

- (instancetype)initWithUUID:(NSString *)uuid name:(NSString *)name systemAdded:(BOOL)systemAdded;
+ (instancetype)itemWithUUID:(NSString *)uuid name:(NSString *)name systemAdded:(BOOL)systemAdded;

- (PCItem *)topSuperior;
- (BOOL)hasSubordinate;
- (BOOL)relativeWithOther:(PCItem *)item;

@end
