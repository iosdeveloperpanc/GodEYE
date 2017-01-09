//
//  PCRelationData.h
//  test
//
//  Created by panchao on 16/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCItem;
@class PCGrade;

@interface PCRelationData : NSObject

@property (nonatomic, strong) PCItem *boss;
@property (nonatomic, strong) NSMutableArray<PCItem *> *items;

+ (instancetype)data;

@end
