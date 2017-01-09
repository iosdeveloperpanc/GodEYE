//
//  PCRelationShip.h
//  test
//
//  Created by panchao on 17/1/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCItem;

@interface PCRelationShip : NSObject

@property (nonatomic, strong, readonly) PCItem *startItem;
@property (nonatomic, strong, readonly) PCItem *endItem;
@property (nonatomic, copy, readonly) NSString *shipName;

- (instancetype)initWithStartItem:(PCItem *)startItem endItem:(PCItem *)endItem shipName:(NSString *)shipName;
+ (instancetype)relationShipWithStartItem:(PCItem *)startItem endItem:(PCItem *)endItem shipName:(NSString *)shipName;

@end
